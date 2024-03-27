
part of 'package:sample_latest/services/db/offline_handler.dart';

class _TodoListDbHandler extends DbHandler {

  _TodoListDbHandler._internal();

  static final _TodoListDbHandler _singleton = _TodoListDbHandler._internal();

  factory _TodoListDbHandler() {
    return _singleton;
  }

  final DbInfo dbInfo = (dbName: 'todolist', dbVersion: 5, queryFileName: 'create_todolist_table_queries');

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
        case RequestType.post:case RequestType.patch: case RequestType.put:
        return performPostOperation(options);
        case RequestType.delete:
          return performDeleteOperation(options);
        default:
          throw DioException(
              requestOptions: options,
              error:  OfflineException(),
              type: DioExceptionType.unknown,
              message : DbConstants.notSupportedOfflineErrorMsg);      }

  }

  @override
  Future<Response> performDeleteOperation(RequestOptions options) {
    // TODO: implement performDeleteOperation
    throw UnimplementedError();
  }

  @override
  Future<Response> performGetOperation(RequestOptions options) {
    // TODO: implement performGetOperation
    throw UnimplementedError();
  }

  @override
  Future<Response> performPatchOperation(RequestOptions options) {
    // TODO: implement performPatchOperation
    throw UnimplementedError();
  }

  @override
  Future<Response> performPostOperation(RequestOptions options) {
    // TODO: implement performPostOperation
    throw UnimplementedError();
  }

  @override
  Future<Response> performBulkLocalDataStoreOperation(RequestOptions options) {
    // TODO: implement _performBulkStoreOperation
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteOutdatedData(int millisecondsSinceEpoch) async {
    await initializeDbIfNot();
    await _dbHandler.deleteTableRowsBasedOnTheDate(millisecondsSinceEpoch);
    return true;
  }

  @override
  Future<bool> resetDataBase() async {
    await initializeDbIfNot();
    return await _dbHandler.resetDataBase();
  }
}
