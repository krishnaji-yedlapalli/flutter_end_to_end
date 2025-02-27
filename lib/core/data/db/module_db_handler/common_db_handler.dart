
part of 'package:sample_latest/core/data/db/offline_handler.dart';

class _CommonDbHandler extends DbHandler {
  _CommonDbHandler._internal();

  static final _CommonDbHandler _singleton = _CommonDbHandler._internal();

  factory _CommonDbHandler() {
    return _singleton;
  }

  final DbInfo dbInfo = (dbName: 'common', dbVersion: 5, queryFileName: 'create_common_tables_queries');

  @override
  Future<bool> initializeDbIfNot() async {
    return await super.initializeDb(dbInfo);
  }

  @override
  Future<Response> performCrudOperation(RequestOptions options) async {

    await super.initializeDb(dbInfo);

    var response;
    try {
      switch (requestType(options.method)) {
        case RequestType.get:
          return performGetOperation(options);
        case RequestType.post:
        case RequestType.patch:
        case RequestType.put:
          return performPatchOperation(options);
        case RequestType.delete:
          return performDeleteOperation(options);
        default:
          return Response(
              requestOptions: options,
              data: response,
              statusCode: 405,
              statusMessage: 'Method Not Allowed');
      }
    } catch (e) {
      return Response(
          requestOptions: options,
          data: response,
          statusCode: 500,
          statusMessage: 'Internal Exception');
    }
  }

  @override
  Future<Response> performDeleteOperation(RequestOptions options) async {

    if(options.path.contains(DbConstants.queueItems)) {

      int recordId = await dbHandler.deleteRecord(
          tableName: DbConstants.queueItems, columnName: DbConstants.idColumnName, ids: [options.queryParameters['id']]);
    }
    return Response(requestOptions: options, statusCode: 200);
  }

  @override
  Future<Response> performGetOperation(RequestOptions options) async {
    if (options.path.contains(DbConstants.queueItems)) {
      List<Map<String, dynamic>>? queueItems =
          await dbHandler.query(DbConstants.queueItems);
      return Response(
          requestOptions: options, data: queueItems ?? [], statusCode: 200);
    }

    return Response(
        requestOptions: options,
        data: {},
        statusCode: 405,
        statusMessage: 'Method Not Allowed');
  }

  @override
  Future<Response> performPatchOperation(RequestOptions options) async {

    if (options.isFromQueueItem) {

      /// storing in queue items
      var queueItem = QueueItem(options.path, options.method,
          body: options.data,
          id: options.data is Map && options.data.keys.isNotEmpty ? options.data.keys.first : null,
          queryParams: options.queryParameters,
          priority: options.priority);

      var queueItemBody = queueItem.toJson();
      if(queueItem.body != null) queueItemBody['body'] = jsonEncode(queueItem.body);
      queueItemBody['queryParams'] = jsonEncode(queueItem.queryParams);

      var res =
          await dbHandler.insertData(DbConstants.queueItems, queueItemBody);
      return Response(requestOptions: options, data: true, statusCode: 200);
    }

    return Response(
        requestOptions: options,
        data: {},
        statusCode: 405,
        statusMessage: 'Method Not Allowed');
  }

  @override
  Future<Response> performPostOperation(RequestOptions options) {
    // TODO: implement performPostOperation
    throw UnimplementedError();
  }

  Future<int> queueItemsCount() async {

    await super.initializeDb(dbInfo);

    var result = await dbHandler.rawQueryWithParams('SELECT COUNT(*) FROM ${DbConstants.queueItems}');
    return result;
  }

  Future<int> insertQueueItem(RequestOptions options) async {

    await super.initializeDb(dbInfo);

    options.isFromQueueItem = true;
    await performPatchOperation(options);
    return 1;
  }


  Future<int> deleteQueueItem(int id) async {

    await super.initializeDb(dbInfo);

    int recordId = await dbHandler.deleteRecord(
        tableName: DbConstants.queueItems, columnName: DbConstants.queueColumnName, ids: [id]);
  return recordId;
  }

  @override
  Future<Response> performBulkLocalDataStoreOperation(RequestOptions options) async {

    await super.initializeDb(dbInfo);

    // TODO: implement _performBulkStoreOperation
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
