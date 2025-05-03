import 'package:flutter/material.dart';
import 'package:sample_latest/core/local_server/handlers/base_request_handler.dart';
import 'package:sample_latest/core/local_server/local_server_manager.dart';
import 'package:shelf/shelf.dart';

import '../model/callback_response_handler.dart';

// Server Initialization Widget
class ServerInitializeWrapper extends StatefulWidget {
  final Widget child;
  final BaseRequestHandler serverRequestHandler;
  final int? port;
  final String? address;
  final void Function(String)? onError;
  final void Function()? onSuccess;

  const ServerInitializeWrapper({
    Key? key,
    required this.child,
    required this.serverRequestHandler,
    this.port,
    this.address,
    this.onError,
    this.onSuccess,
  }) : super(key: key);

  @override
  State<ServerInitializeWrapper> createState() => _ServerInitializeWrapperState();
}

class _ServerInitializeWrapperState extends State<ServerInitializeWrapper> {
  late final LocalServerManager _serverManager;
  late final BaseRequestHandler _requestHandler;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _serverManager = LocalServerManager.instance;
    _requestHandler = widget.serverRequestHandler;
    _initializeServer();
  }

  Future<void> _initializeServer() async {
    try {
      await _serverManager.initialize(
        port: widget.port,
        ipAddress: widget.address,
        callback: _handleServerRequest,
      );

      setState(() {
        _isInitialized = true;
      });

      widget.onSuccess?.call();
    } catch (e) {
      widget.onError?.call(e.toString());
    }
  }

  Future<Result<dynamic>> _handleServerRequest(dynamic data) async {
    if (data is Map && data['request'] != null) {
      final request = data['request'] as Request;
      return await _requestHandler.handleRequest(request);
    }
    return Result.ok(null);
  }

  @override
  void dispose() {
    _serverManager.uninitialize();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Future.value(), // Server is initialized in initState
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error initializing server: ${snapshot.error}'),
          );
        }

        if (!_isInitialized) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return widget.child;
      },
    );
  }
}