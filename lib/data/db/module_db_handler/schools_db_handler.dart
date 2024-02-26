import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sample_latest/data/db/db_handler.dart';
import 'package:sample_latest/data/db/module_db_handler/common_db_handler.dart';
import 'package:sample_latest/data/urls.dart';
import 'package:sample_latest/data/utils/abstract_db_handler.dart';
import 'package:sample_latest/data/utils/db_constants.dart';
import 'package:sample_latest/data/utils/enums.dart';
import 'package:sample_latest/mixins/helper_methods.dart';

import '../../models/services/queue_item.dart';

class SchoolsDbHandler extends DbHandler {
  SchoolsDbHandler._internal();

  static final SchoolsDbHandler _singleton = SchoolsDbHandler._internal();

  factory SchoolsDbHandler() {
    return _singleton;
  }

  final _dbName = 'school';

  final _sqlQueries = 'create_school_table_queries';

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
    var id = options.path.split('/').last.split('.').first;
    String? dbName;

    if (options.path.contains(Urls.schools)) {
      dbName = SchoolDbConstants.schoolsTableName;
    } else if (options.path.contains(Urls.schoolDetails)) {
      dbName = SchoolDbConstants.schoolDetailsTableName;
    } else if (options.path.contains(Urls.students)) {
      dbName = SchoolDbConstants.studentsTableName;
    }

    if (dbName != null) {
      int recordId = await dbHandler!.deleteRecord(
          tableName: dbName, columnName: DbConstants.idColumnName, ids: [id]);
    } else {
      return Response(
          requestOptions: options,
          data: false,
          statusCode: 405,
          statusMessage: 'Method Not Allowed');
    }

    return Response(requestOptions: options, data: true, statusCode: 200);
  }

  @override
  Future<Response> performGetOperation(RequestOptions options) async {
    if (options.path.contains(Urls.schools)) {
      /// To get the school details
      List<Map<String, dynamic>>? schools =
          await dbHandler!.query(SchoolDbConstants.schoolsTableName);
      return Response(
          requestOptions: options, data: schools ?? [], statusCode: 200);
    } else if (options.path.contains(Urls.schoolDetails)) {
      /// To get the school added details
      List<Map<String, dynamic>>? schoolDetailsList = await dbHandler!.query(
          SchoolDbConstants.schoolDetailsTableName,
          columnName: DbConstants.idColumnName,
          ids: [options.path.split('/').last.split('.').first]);

      Map<String, dynamic>? schoolDetails =
          schoolDetailsList?.isNotEmpty ?? false
              ? Map<String, dynamic>.from(schoolDetailsList?.first ?? {})
              : null;
      schoolDetails?['hostelAvailability'] =
          schoolDetails['hostelAvailability'] == 1 ? true : false;

      return Response(
          requestOptions: options, data: schoolDetails, statusCode: 200);
    } else if (options.path.contains(Urls.students)) {
      var paths = options.path.split('/');
      if (paths.length >= 2 &&
          paths[paths.length - 2].contains(Urls.students)) {
        List<Map<String, dynamic>>? students = await dbHandler!.query(
            SchoolDbConstants.studentsTableName,
            columnName: SchoolDbConstants.schoolIdColumnName,
            ids: [paths.last.split('.').first]);
        return Response(
            requestOptions: options, data: students ?? [], statusCode: 200);
      } else {
        /// To get the students based on the school
        List<Map<String, dynamic>>? students = await dbHandler!.query(
            SchoolDbConstants.studentsTableName,
            columnName: DbConstants.idColumnName,
            ids: [paths.last.split('.').first]);
        return Response(
            requestOptions: options, data: students?.first, statusCode: 200);
      }
    }

    return Response(
        requestOptions: options,
        data: {},
        statusCode: 405,
        statusMessage: 'Method Not Allowed');
  }

  @override
  Future<Response> performPatchOperation(RequestOptions options) async {
    if (options.path.contains(Urls.schools)) {
      /// Storing school information

      var body = options.data[options.data.keys.first];
      var schools =
          await dbHandler!.insertData(SchoolDbConstants.schoolsTableName, body);
      body = {body['id']: body};

      options.extra['isQueueItem'] = true;
      options.extra['priority'] = 1;
      CommonDbHandler().performDbOperation(options);
      return Response(requestOptions: options, data: body, statusCode: 200);
    } else if (options.path.contains(Urls.schoolDetails)) {
      /// Storing school Details information
      var body = options.data[options.data.keys.first];
      var schools = await dbHandler!
          .insertData(SchoolDbConstants.schoolDetailsTableName, body);
      body = {body['id']: body};

      options.extra['isQueueItem'] = true;
      options.extra['priority'] = 1;
      CommonDbHandler().performDbOperation(options);
      return Response(requestOptions: options, data: body, statusCode: 200);
    } else if (options.path.contains(Urls.students)) {
      /// Storing student information
      var body = options.data[options.data.keys.first];
      var schools = await dbHandler!
          .insertData(SchoolDbConstants.studentsTableName, body);
      body = {body['id']: body};

      options.extra['isQueueItem'] = true;
      options.extra['priority'] = 1;
      CommonDbHandler().performDbOperation(options);
      return Response(requestOptions: options, data: body, statusCode: 200);
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

  @override
  Future<void> getOfflineData() async {
    var data = <String>[];

    List<String> list = [
      SchoolDbConstants.schoolsTableName,
      SchoolDbConstants.schoolDetailsTableName,
      SchoolDbConstants.studentsTableName
    ];

    for (var dbName in list) {
      var reqDatas = await dbHandler!.db
          .query(dbName, where: '${DbConstants.reqDataColumnName} IS NULL');
      for (var reqData in reqDatas) {
        // data.add(reqData);
      }
    }
  }
}
