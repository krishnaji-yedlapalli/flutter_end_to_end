import 'package:dio/dio.dart';
import 'package:sample_latest/extensions/dio_request_extension.dart';
import 'package:sample_latest/services/db/db_configuration.dart';
import 'package:sample_latest/services/db/offline_handler.dart';
import 'package:sample_latest/utils/connectivity_handler.dart';
import 'package:sample_latest/utils/device_configurations.dart';

class Interceptors extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    if (!ConnectivityHandler().isConnected && options.isOfflineApi && DeviceConfiguration.isOfflineSupportedDevice && DbConfigurationsByDev.storeData && !options.isFromQueueItem) {
      OfflineHandler().handleRequest(options, handler);
    }else {
      super.onRequest(options, handler);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {

    if(DbConfigurationsByDev.storeInBothOfflineAndOnline && response.requestOptions.isOfflineApi && !response.requestOptions.isFromQueueItem){
      response.requestOptions.notRequiredToStoreInQueue = true;
      await OfflineHandler().handleRequest(response.requestOptions, handler);
    }
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if(err.type == DioExceptionType.connectionError && (err.requestOptions.isOfflineApi) && DbConfigurationsByDev.storeData && !err.requestOptions.isFromQueueItem){
      OfflineHandler().handleRequest(err.requestOptions, handler);
    }else{
      super.onError(err, handler);
    }
  }
}
