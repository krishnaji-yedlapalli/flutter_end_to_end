import 'package:http/testing.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:sample_latest/data/db/offline_handler.dart';

class Interceptors extends InterceptorContract {

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    
    // if(response.statusCode != 200){
    //   return OfflineHandler().handleRequest();
    // }
    return response;
  }
}
