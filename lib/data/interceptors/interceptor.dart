import 'package:http/testing.dart';
import 'package:http_interceptor/http_interceptor.dart';

class Interceptors extends InterceptorContract {

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    return Future.value(response);
  }
}
