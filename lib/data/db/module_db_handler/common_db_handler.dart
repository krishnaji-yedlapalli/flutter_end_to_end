import 'dart:convert';

import 'package:dio/src/options.dart';
import 'package:dio/src/response.dart';
import 'package:sample_latest/data/db/db_handler.dart';
import 'package:sample_latest/data/models/services/queue_item.dart';
import 'package:sample_latest/data/utils/abstract_db_handler.dart';
import 'package:sample_latest/data/utils/db_constants.dart';
import 'package:sample_latest/data/utils/enums.dart';
import 'package:sample_latest/mixins/helper_methods.dart';

class CommonDbHandler extends DbHandler {
  CommonDbHandler._internal();

  static final CommonDbHandler _singleton = CommonDbHandler._internal();

  factory CommonDbHandler() {
    return _singleton;
  }

  final _dbName = 'common';

  final _sqlQueries = 'create_common_tables_queries';

  @override
  Future<Response> performDbOperation(RequestOptions options) async {
    super.dbHandler ??= await SqfLiteDbHandler.create(_dbName, _sqlQueries);
    return await performCrudOperation(options);
  }

  @override
  Future<Response> performCrudOperation(RequestOptions options) async {
    var requestType = HelperMethods.enumFromString(
        RequestType.values, options.method.toLowerCase());

    var response;
    try {
      switch (requestType) {
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

      int recordId = await dbHandler!.deleteRecord(
          tableName: DbConstants.queueItems, columnName: DbConstants.idColumnName, ids: [options.queryParameters['id']]);
    }
    return Response(requestOptions: options, statusCode: 200);
  }

  @override
  Future<Response> performGetOperation(RequestOptions options) async {
    if (options.path.contains(DbConstants.queueItems)) {
      List<Map<String, dynamic>>? queueItems =
          await dbHandler!.query(DbConstants.queueItems);
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

    if (options.extra['isQueueItem'] ?? false) {

      /// storing in queue items
      var queueItem = QueueItem(options.path, options.method,
          body: options.data,
          id: options.data is Map && options.data.keys.isNotEmpty ? options.data.keys.first : null,
          queryParams: options.queryParameters,
          priority: options.extra['priority'] ?? -1);

      var queueItemBody = queueItem.toJson();
      if(queueItem.body != null) queueItemBody['body'] = jsonEncode(queueItem.body);
      queueItemBody['queryParams'] = jsonEncode(queueItem.queryParams);

      var res =
          await dbHandler!.insertData(DbConstants.queueItems, queueItemBody);
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
    super.dbHandler ??= await SqfLiteDbHandler.create(_dbName, _sqlQueries);
    var result = await dbHandler!.rawQueryWithParams('SELECT COUNT(*) FROM ${DbConstants.queueItems}');
    return result;
  }

  Future<int> insertQueueItem(RequestOptions options) async {
    super.dbHandler ??= await SqfLiteDbHandler.create(_dbName, _sqlQueries);
    options.extra['isQueueItem'] = true;
    await performPatchOperation(options);
    return 1;
  }


  Future<int> deleteQueueItem(int id) async {
    super.dbHandler ??= await SqfLiteDbHandler.create(_dbName, _sqlQueries);

    int recordId = await dbHandler!.deleteRecord(
        tableName: DbConstants.queueItems, columnName: DbConstants.queueColumnName, ids: [id]);
  return recordId;
  }

}
