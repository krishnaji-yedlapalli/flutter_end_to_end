

import 'package:dio/dio.dart';
import 'package:sample_latest/services/utils/service_enums_typedef.dart';

class OfflineException implements Exception {

  final Object? error;

  final StackTrace? stackTrace;

  OfflineException({this.error, this.stackTrace});

}