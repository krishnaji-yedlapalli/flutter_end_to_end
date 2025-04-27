
import '../model/callback_response_handler.dart';

import 'dart:convert';

import 'package:shelf/shelf.dart';

abstract class BaseRequestHandler {
  Future<Result<dynamic>> handleRequest(Request request);

  // Common utility methods that all handlers might need
  Future<Map<String, dynamic>> parseJsonBody(Request request) async {
    try {
      final String body = await request.readAsString();
      return json.decode(body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Invalid JSON body');
    }
  }

  Response createJsonResponse(dynamic data, {int statusCode = 200}) {
    return Response(
      statusCode,
      body: json.encode(data),
      headers: {'content-type': 'application/json'},
    );
  }

  error(String message) {
    // TODO: implement error
    throw UnimplementedError();
  }

  String success(dyamic) {
    return '';
  }


  }