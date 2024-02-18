import 'package:dio/dio.dart';
import 'package:sample_latest/data/db/module_db_handler/schools_db_handler.dart';
import 'package:sample_latest/data/db/module_db_handler/todo_list_db_handler.dart';
import 'package:sample_latest/data/urls.dart';

class OfflineHandler {
  factory OfflineHandler() {
    return _singleton;
  }

  static final OfflineHandler _singleton = OfflineHandler._internal();

  OfflineHandler._internal();

  Future<Response> handleRequest(RequestOptions options) async {

    String path = options.path;

    try {
      if (path.contains(Urls.schools) || path.contains(Urls.schools) || path.contains(Urls.schools)) {
        return await SchoolsDbHandler().performDbOperation(options);
      } else if (path.contains(Urls.todoList)) {
        return await TodoListDbHandler().performDbOperation(options);
      }else{
        throw DioException(requestOptions: options, type: DioExceptionType.connectionError);
      }
    } catch (e, s) {
      throw DioException(requestOptions: options, type: DioExceptionType.connectionError);
    }
  }
}
