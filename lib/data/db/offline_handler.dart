
import 'package:http_interceptor/http_interceptor.dart';

class OfflineHandler {

  factory OfflineHandler() {
    return _singleton;
  }

  static final OfflineHandler _singleton = OfflineHandler._internal();

  OfflineHandler._internal();

  Response? handleRequest(BaseRequest request) {
    return null;
  }
}