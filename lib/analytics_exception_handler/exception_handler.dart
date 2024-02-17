import 'dart:io';

import 'package:sample_latest/analytics_exception_handler/error_logging.dart';
import 'package:sample_latest/analytics_exception_handler/server_exception.dart';
import 'package:sample_latest/mixins/notifiers.dart';
import 'package:sample_latest/utils/enums.dart';

class ExceptionHandler {
  static final ExceptionHandler _singleton = ExceptionHandler._internal();

  factory ExceptionHandler() {
    return _singleton;
  }

  ExceptionHandler._internal();

  void handleExceptionWithToastNotifier(Object exception,
  { StackTrace? stackTrace, String? toastMessage}){
    var errorStateType = handleException(exception, stackTrace);

    switch(errorStateType) {

      case DataErrorStateType.noInternet:
        Notifiers.toastNotifier('Check your Internet connection!!!');
      case DataErrorStateType.serverNotFound:
        Notifiers.toastNotifier('Unable to connect the Server!!!');
      case DataErrorStateType.somethingWentWrong: case DataErrorStateType.fetchData:
        Notifiers.toastNotifier('Unknown Exception occurred!!!');
      case DataErrorStateType.unauthorized:
        Notifiers.toastNotifier('Not Authorized!!!');
      case DataErrorStateType.none:
        if(toastMessage != null) Notifiers.toastNotifier(toastMessage);
    }

  }

  DataErrorStateType handleException(Object exception,
      [StackTrace? stackTrace]) {
    var errorStateType = DataErrorStateType.none;

    switch (exception.runtimeType) {
      case ServerException:
        errorStateType = handleServerException(exception as ServerException, stackTrace);
        break;
      case HttpException:
        errorStateType = handleNetworkExceptions(exception as Exception, stackTrace);
        break;
      case SocketException:
        errorStateType = DataErrorStateType.noInternet;
    }

    return errorStateType;
  }

  DataErrorStateType handleServerException(
      ServerException exception, StackTrace? stackTrace) {
    var errorStateType = DataErrorStateType.none;

    switch (exception.statusCode) {
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
      default:
        ErrorLogging.errorLog(exception, message: 'Unknown Server exception');
    }
    return errorStateType;
  }

  DataErrorStateType handleNetworkExceptions(
      Exception exception, StackTrace? stackTrace) {
    var errorStateType = DataErrorStateType.none;

    switch (exception.runtimeType) {
      case SocketException:
        errorStateType = DataErrorStateType.noInternet;
        break;
      default:
        ErrorLogging.errorLog(exception, message: 'Unknown Network exception');
    }
    return errorStateType;
  }

  void handleErrors() {}
}
