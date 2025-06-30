
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/core/local_server/handlers/base_request_handler.dart';
import 'package:shelf/shelf.dart';

import '../../../../../core/local_server/model/callback_response_handler.dart';
import '../../../features/domain/cubit/smart_control_dashboard_cubit.dart';

class SmartControlServerRequestHandler implements BaseRequestHandler {

  final BuildContext context;

  const SmartControlServerRequestHandler(this.context);

  @override
  Future<Result<dynamic>> handleRequest(Request request) async {

    try {
      print('##** path :  ${request.url.path}');
      switch (request.url.path) {
        case 'motion':
          if(context.mounted) {
            final state = context.read<SmartControlMqttDashboardCubit>()
                .state;
            if (state is SCDashboardLoaded) {
              final body = await request.readAsString(); // Get request body
              Map<String, dynamic> result = jsonDecode(body); // Parse JSON
              // state.smCubits.entries.first.value.updateDeviceStatus(result['motion'] ?? false);
            }
          }
          return Result.ok('sucees');
          // return await _handleUsersRequest(request);
        case 'api/products':
          // return await _handleProductsRequest(request);
        case 'api/settings':
          // return await _handleSettingsRequest(request);
        default:
          return Result.error('Route not found');
      }
    } catch (e) {
      return Result.error('Error processing request: $e');
    }
  }

  @override
  createJsonResponse(data, {int statusCode = 200}) {
    // TODO: implement createJsonResponse
    throw UnimplementedError();
  }

  @override
  error(String message) {
    // TODO: implement error
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> parseJsonBody(request) {
    // TODO: implement parseJsonBody
    throw UnimplementedError();
  }

  @override
  success(data) {
    // TODO: implement success
    throw UnimplementedError();
  }
}