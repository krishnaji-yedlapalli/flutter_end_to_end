import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'model/callback_response_handler.dart';

// Updated callback typedef to return Result
typedef ServerCallback = Future<Result<dynamic>> Function(dynamic data);

class LocalServerManager {
  static final LocalServerManager _instance = LocalServerManager._internal();

  LocalServerManager._internal();

  static LocalServerManager get instance => _instance;

  HttpServer? _server;
  bool _isInitialized = false;
  final Set<ServerCallback> _callbacks = {};

  Future<void> initialize({
    int? port,
    String? ipAddress,
    ServerCallback? callback,
  }) async {
    if (callback != null) {
      registerCallback(callback);
    }

    if (_isInitialized) {
      return;
    }

    try {
      final handler = const Pipeline()
          .addMiddleware(logRequests())
          .addHandler(_handleRequest);

      // Get the device's local IP address
      var ip = ipAddress ?? await _getLocalIpAddress();

      debugPrint('ip address : $ip');
      _server = await shelf_io.serve(handler, ip, port ?? 8080);
      _isInitialized = true;

      await _notifyCallbacks(Result.ok('Server started on port: ${_server?.port}'));
    } catch (e) {
      await _notifyCallbacks(Result.error('Server initialization failed: $e'));
      rethrow;
    }
  }

  Future<Response> _handleRequest(Request request) async {
    try {
      // Notify callbacks about the incoming request and wait for their responses
      final result = await _notifyCallbacks({
        'method': request.method,
        'url': request.url.toString(),
        'headers': request.headers,
        'request': request,
      });

      if (result.isSuccess) {
        // If the callback provided a Response, use it
        if (result.data is Response) {
          return result.data as Response;
        }
        // Otherwise, return a successful response with the data
        return Response.ok(json.encode({'data': result.data}));
      } else {
        // Handle error case
        return Response.internalServerError(
          body: json.encode({'error': result.error}),
        );
      }
    } catch (e) {
      await _notifyCallbacks(Result.error('Error handling request: $e'));
      return Response.internalServerError(body: 'Internal Server Error');
    }
  }

  void registerCallback(ServerCallback callback) {
    _callbacks.add(callback);
  }

  void unregisterCallback(ServerCallback callback) {
    _callbacks.remove(callback);
  }

  // Updated to handle multiple callbacks and return combined result
  Future<Result<dynamic>> _notifyCallbacks(dynamic data) async {
    if (_callbacks.isEmpty) {
      return Result.ok(null);
    }

    try {
      for (final callback in _callbacks) {
        final result = await callback(data);
        if (!result.isSuccess) {
          return result; // Return first error encountered
        }
        if (result.data is Response) {
          return result; // Return first Response encountered
        }
      }
      return Result.ok(null);
    } catch (e) {
      return Result.error('Error in callback execution: $e');
    }
  }

  bool get isInitialized => _isInitialized;

  HttpServer? get server => _server;

  Future<String> _getLocalIpAddress() async {
    var interfaces = await NetworkInterface.list();
    print('interfaces length : ${interfaces.length}');
    for (var interface in interfaces) {
      if (interface.addresses.isNotEmpty && interface.name != 'lo0') {
        return interface.addresses.first.address;
      }
    }
    return 'localhost';
  }

  Future<void> uninitialize() async {
    if (!_isInitialized) return;

    try {
      await _server?.close();
      _server = null;
      _isInitialized = false;
      await _notifyCallbacks(Result.ok('Server stopped'));
    } catch (e) {
      await _notifyCallbacks(Result.error('Error stopping server: $e'));
      rethrow;
    }
  }

  void clearCallbacks() {
    _callbacks.clear();
  }
}