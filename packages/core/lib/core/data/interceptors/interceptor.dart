import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:app_core/core/data/db/db_config_repository.dart';
import 'package:app_core/core/data/db/offline_handler.dart';
import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/core/extensions/dio_request_extension.dart';
import 'package:app_core/core/utils/connectivity_handler.dart';

class RequestBypassInterceptor extends Interceptor {
  bool get _isOfflineSupported =>
      GetIt.instance.isRegistered<DbConfigRepository>() &&
      GetIt.instance.isRegistered<OfflineHandler>();

  DbConfigRepository get _dbConfig => GetIt.instance<DbConfigRepository>();
  OfflineHandler get _offlineHandler => GetIt.instance<OfflineHandler>();

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (_isOfflineSupported &&
        !ConnectivityHandler().isConnected &&
        options.isOfflineApi &&
        DeviceConfiguration.isOfflineSupportedDevice &&
        _dbConfig.state.storeData &&
        !options.isFromQueueItem) {
      await _offlineHandler.handleRequest(options, handler);
    } else {
      super.onRequest(options, handler);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (_isOfflineSupported &&
        _dbConfig.state.storeInBothOfflineAndOnline &&
        response.requestOptions.isOfflineApi &&
        !response.requestOptions.isFromQueueItem) {
      response.requestOptions.notRequiredToStoreInQueue = true;
      await _offlineHandler.storeLocally(response.requestOptions);
    }
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_isOfflineSupported &&
        err.type == DioExceptionType.connectionError &&
        (err.requestOptions.isOfflineApi) &&
        _dbConfig.state.storeData &&
        !err.requestOptions.isFromQueueItem) {
      await _offlineHandler.handleRequest(err.requestOptions, handler);
    } else {
      super.onError(err, handler);
    }
  }
}
