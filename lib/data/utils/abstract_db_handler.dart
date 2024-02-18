

import 'package:dio/dio.dart';
import 'package:sample_latest/data/db/db_handler.dart';
import 'package:sqflite/sqflite.dart';

abstract class DbHandler {

  SqfLiteDbHandler? dbHandler;

  Future<Response> performDbOperation(RequestOptions options);

  Future<Response> performCrudOperation(RequestOptions options);

  Future<Response> performPostOperation(RequestOptions options);

  Future<Response> performGetOperation(RequestOptions options);

  Future<Response> performDeleteOperation(RequestOptions options);

  Future<Response> performPatchOperation(RequestOptions options);

}
