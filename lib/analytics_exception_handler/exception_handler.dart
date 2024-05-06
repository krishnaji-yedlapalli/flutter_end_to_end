import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sample_latest/analytics_exception_handler/custom_exception.dart';
import 'package:sample_latest/analytics_exception_handler/error_reporting.dart';
import 'package:sample_latest/services/utils/service_enums_typedef.dart';
import 'package:sample_latest/mixins/notifiers.dart';

class ExceptionHandler {
  static final ExceptionHandler _singleton = ExceptionHandler._internal();

  factory ExceptionHandler() {
    return _singleton;
  }

  ExceptionHandler._internal();

  void handleExceptionWithToastNotifier(Object exception, {StackTrace? stackTrace, String? toastMessage}) {
    ErrorDetails errorStateType = handleException(exception, stackTrace);
    late String notifierText;

    switch (errorStateType.$1) {
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
        notifierText =  toastMessage ?? 'Unknown Exception occurred!!!';
      case DataErrorStateType.timeoutException:
        notifierText = 'Timeout Exception!!!';
      case DataErrorStateType.offlineError:
        notifierText = exception is DioException ? exception.message ?? '' : 'Unknown Exception occurred!!!';
    }

    Notifiers.toastNotifier(notifierText);
  }

  ErrorDetails handleException(Object exception, [StackTrace? stackTrace]) {
    ErrorDetails errorStateType = (DataErrorStateType.none, message: null);

    if (exception is DioException) {
      errorStateType = handleServerException(exception, stackTrace);
    } else {

    }

    return errorStateType;
  }

  ErrorDetails handleServerException(DioException exception, StackTrace? stackTrace) {
    var errorStateType = DataErrorStateType.none;
    String? message;

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
          case 500:case 502:
            errorStateType = DataErrorStateType.serverNotFound;
            break;
        }
      case DioExceptionType.unknown:
        if(exception.error is OfflineException) {
          errorStateType = DataErrorStateType.offlineError;
          message = exception.message;
        }else{
          errorStateType = DataErrorStateType.somethingWentWrong;
          ReportError.errorLog(exception);
        }
      default:
        ReportError.errorLog(exception);
    }
    return (errorStateType, message: message);
  }

  DataErrorStateType handleNetworkExceptions(Exception exception, StackTrace? stackTrace) {
    var errorStateType = DataErrorStateType.none;

    switch (exception.runtimeType) {
      case SocketException:
        errorStateType = DataErrorStateType.noInternet;
        break;
      default:
        ReportError.errorLog(exception);
    }
    return errorStateType;
  }

  void handleErrors() {}
}
