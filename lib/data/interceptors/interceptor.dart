import 'package:dio/dio.dart';
import 'package:sample_latest/data/db/offline_handler.dart';
import 'package:sample_latest/utils/connectivity_handler.dart';

class Interceptors extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    // if (!ConnectivityHandler().isConnected) {
    //   handler.resolve(await OfflineHandler().handleRequest(options));
    // }
    await OfflineHandler().handleRequest(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {

    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
