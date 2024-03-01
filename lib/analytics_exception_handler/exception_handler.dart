import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:sample_latest/analytics_exception_handler/error_logging.dart';
import 'package:sample_latest/analytics_exception_handler/server_exception.dart';
import 'package:sample_latest/data/utils/enums.dart';
import 'package:sample_latest/mixins/notifiers.dart';
import 'package:sample_latest/utils/enums.dart';

class ExceptionHandler {
  static final ExceptionHandler _singleton = ExceptionHandler._internal();

  factory ExceptionHandler() {
    return _singleton;
  }

  ExceptionHandler._internal();

  void handleExceptionWithToastNotifier(Object exception, {StackTrace? stackTrace, String? toastMessage}) {
    var errorStateType = handleException(exception, stackTrace);
    late String notifierText;

    switch (errorStateType) {
      case DataErrorStateType.noInternet:
        notifierText = 'Check your Internet connection!!!';
      case DataErrorStateType.serverNotFound:
        notifierText = 'Unable to connect the Server!!!';
      case DataErrorStateType.somethingWentWrong:
      case DataErrorStateType.fetchData:
        notifierText = 'Unknown Exception occurred!!!';
      case DataErrorStateType.unauthorized:
        notifierText = 'Not Authorized!!!';
      case DataErrorStateType.none:
        if (toastMessage != null) notifierText = toastMessage;
      case DataErrorStateType.timeoutException:
        notifierText = 'Timeout Exception!!!';
    }

    Notifiers.toastNotifier(notifierText);
  }

  DataErrorStateType handleException(Object exception, [StackTrace? stackTrace]) {
    var errorStateType = DataErrorStateType.none;

    if (exception is DioException) {
      errorStateType = handleServerException(exception, stackTrace);
    } else {}

    return errorStateType;
  }

  DataErrorStateType handleServerException(DioException exception, StackTrace? stackTrace) {
    var errorStateType = DataErrorStateType.none;

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        errorStateType = DataErrorStateType.timeoutException;
        break;
      case DioExceptionType.connectionError:
        errorStateType = DataErrorStateType.noInternet;
        break;
      case DioExceptionType.badResponse:
        switch (exception.response?.statusCode) {
          case 400:
            errorStateType = DataErrorStateType.fetchData;
            break;
          case 401:
          case 403:
            errorStateType = DataErrorStateType.unauthorized;
            break;
          case 500:
            errorStateType = DataErrorStateType.unauthorized;
            break;
          case 502:
            errorStateType = DataErrorStateType.serverNotFound;
            break;
        }
      case DioExceptionType.unknown:
        errorStateType = DataErrorStateType.somethingWentWrong;
      default:
        ErrorLogging.errorLog(exception);
    }
    return errorStateType;
  }

  DataErrorStateType handleNetworkExceptions(Exception exception, StackTrace? stackTrace) {
    var errorStateType = DataErrorStateType.none;

    switch (exception.runtimeType) {
      case SocketException:
        errorStateType = DataErrorStateType.noInternet;
        break;
      default:
        ErrorLogging.errorLog(exception);
    }
    return errorStateType;
  }

  void handleErrors() {}
}
