

import 'package:http/http.dart';

class ServerException implements Exception {

  int statusCode;

  Response response;

  ServerException(this.statusCode, this.response) : super();



}