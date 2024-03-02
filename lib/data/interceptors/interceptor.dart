import 'package:dio/dio.dart';
import 'package:sample_latest/data/db/offline_handler.dart';
import 'package:sample_latest/data/utils/db_constants.dart';
import 'package:sample_latest/utils/connectivity_handler.dart';
import 'package:sample_latest/utils/device_configurations.dart';

class Interceptors extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    if (!ConnectivityHandler().isConnected && (options.extra['isOfflineApi'] ?? false) && !DeviceConfiguration.isWeb) {
      handler.resolve(await OfflineHandler().handleRequest(options));
    }else {
      super.onRequest(options, handler);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {

    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if(err.type == DioExceptionType.connectionError && (err.requestOptions.extra['isOfflineApi'] ?? false)){
      handler.resolve(await OfflineHandler().handleRequest(err.requestOptions));
    }else{
      super.onError(err, handler);
    }
  }
}
