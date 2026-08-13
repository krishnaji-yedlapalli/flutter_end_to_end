import 'package:app_core/analytics_exception_handler/custom_exception.dart';
import 'package:app_core/core/data/urls.dart';
import 'package:app_core/core/data/utils/abstract_db_handler.dart';
import 'package:app_core/core/data/utils/db_constants.dart';
import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import 'package:dio/dio.dart';

class TodoListDbHandler extends DbHandler {
  TodoListDbHandler._internal();

  static final TodoListDbHandler _singleton = TodoListDbHandler._internal();

  factory TodoListDbHandler() {
    return _singleton;
  }

  final DbInfo dbInfo = (
    dbName: 'todolist',
    dbVersion: 5,
    queryFileName: 'lib/core/data/db/queries/create_todolist_table_queries.sql'
  );

  @override
  List<String> get supportedPaths => [Urls.todoList];

  @override
  Future<bool> initializeDbIfNot() async {
    return await super.initializeDb(dbInfo);
  }

  @override
  Future<Response> performCrudOperation(RequestOptions options) async {
    await super.initializeDb(dbInfo);

    switch (requestType(options.method)) {
      case RequestType.get:
        return performGetOperation(options);
      case RequestType.post:
      case RequestType.patch:
      case RequestType.put:
        return performPostOperation(options);
      case RequestType.delete:
        return performDeleteOperation(options);
      default:
        throw DioException(
            requestOptions: options,
            error: OfflineException(),
            type: DioExceptionType.unknown,
            message: DbConstants.notSupportedOfflineErrorMsg);
    }
  }

  @override
  Future<Response> performDeleteOperation(RequestOptions options) {
    throw UnimplementedError();
  }

  @override
  Future<Response> performGetOperation(RequestOptions options) {
    throw UnimplementedError();
  }

  @override
  Future<Response> performPatchOperation(RequestOptions options) {
    throw UnimplementedError();
  }

  @override
  Future<Response> performPostOperation(RequestOptions options) {
    throw UnimplementedError();
  }

  @override
  Future<Response> performBulkLocalDataStoreOperation(RequestOptions options) {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteOutdatedData(int millisecondsSinceEpoch) async {
    await initializeDbIfNot();
    await dbHandler.deleteTableRowsBasedOnTheDate(millisecondsSinceEpoch);
    return true;
  }

  @override
  Future<bool> resetDataBase() async {
    await initializeDbIfNot();
    return await dbHandler.resetDataBase();
  }
}
