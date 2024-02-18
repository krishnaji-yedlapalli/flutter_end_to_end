
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sample_latest/data/db/db_handler.dart';
import 'package:sample_latest/data/utils/abstract_db_handler.dart';
import 'package:sample_latest/data/utils/enums.dart';

class TodoListDbHandler extends DbHandler {

  TodoListDbHandler._internal();

  static final TodoListDbHandler _singleton = TodoListDbHandler._internal();

  factory TodoListDbHandler() {
    return _singleton;
  }

  final _dbName = 'todolist';

  final _sqlQueries = 'create_school_table_queries';

  @override
  Future<Response> performDbOperation(RequestOptions options) async {
    super.dbHandler ??= await SqfLiteDbHandler.create(_dbName, _sqlQueries);
    return await performCrudOperation(options);
  }

  @override
  Future<Response> performCrudOperation(RequestOptions options) async {
    var requestType  =  RequestType.get; /*.enumFromString(RequestType.values, options.method.toLowerCase());*/
    var response;
    try {
      switch (requestType) {
        case RequestType.get:
          return performGetOperation(options);
        case RequestType.post:case RequestType.patch: case RequestType.put:
        return performPostOperation(options);
        case RequestType.delete:
          return performDeleteOperation(options);
        default:
          return Response(requestOptions: options, data: response, statusCode: 405, statusMessage: 'Method Not Allowed');
      }
    } catch (e) {
      return Response(requestOptions: options, data: response, statusCode: 500, statusMessage: 'Internal Exception');
    }
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
}
