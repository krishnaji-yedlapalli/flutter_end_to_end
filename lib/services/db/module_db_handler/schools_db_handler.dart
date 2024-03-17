import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sample_latest/services/db/db_handler.dart';
import 'package:sample_latest/services/db/module_db_handler/common_db_handler.dart';
import 'package:sample_latest/services/urls.dart';
import 'package:sample_latest/services/utils/abstract_db_handler.dart';
import 'package:sample_latest/services/utils/db_constants.dart';
import 'package:sample_latest/services/utils/enums.dart';
import 'package:sample_latest/mixins/helper_methods.dart';

import '../../base_service.dart';

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
        case RequestType.store:
          return performBulkStoreOperation(options);
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

    dynamic id;
    if(options.queryParameters.containsKey(DbConstants.idColumnName)){
      id = options.queryParameters[DbConstants.idColumnName];
    }else{
     id = options.path.split('/').last.split('.').first;
    }
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

      /// Storing the data locally
      if(!(options.extra.containsKey(DbConstants.notRequiredToStoreInQueue) && options.extra[DbConstants.notRequiredToStoreInQueue])) {
        await CommonDbHandler().insertQueueItem(options);
      }
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
    String? tableName;

    if (options.path.contains(Urls.schools)) {
      tableName = SchoolDbConstants.schoolsTableName;
      options.extra['priority'] = 1;
    } else if (options.path.contains(Urls.schoolDetails)) {
      tableName = SchoolDbConstants.schoolDetailsTableName;
      options.extra['priority'] = 2;
    } else if (options.path.contains(Urls.students)) {
      tableName = SchoolDbConstants.studentsTableName;
      options.extra['priority'] = 3;
    }

    if (tableName != null) {
      var body = options.data[options.data.keys.first];
      var response = await dbHandler!.insertData(tableName, body);

      /// Storing the data locally
      if(!(options.extra.containsKey(DbConstants.notRequiredToStoreInQueue) && options.extra[DbConstants.notRequiredToStoreInQueue])) {
        await CommonDbHandler().insertQueueItem(options);
      }
      return Response(requestOptions: options, data: options.data, statusCode: 200);
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

  Future<Response> performBulkStoreOperation(RequestOptions options) async {
    String? tableName;

    if (options.path.contains(Urls.schools)) {
      tableName = SchoolDbConstants.schoolsTableName;
    } else if (options.path.contains(Urls.schoolDetails)) {
      tableName = SchoolDbConstants.schoolDetailsTableName;
    } else if (options.path.contains(Urls.students)) {
      tableName = SchoolDbConstants.studentsTableName;
    }

    if (tableName != null && options.data is Map) {
      List<Map<String, dynamic>> items = <Map<String, dynamic>>[];
      await dbHandler!.deleteTableData(tableName);

        items = (options.data as Map<String, dynamic>).entries.map<
            Map<String, dynamic>>((e) => e.value).toList();

      if(tableName == Urls.students) {
        var innerList = <Map<String, dynamic>>[];
        for (var value in items) {
          innerList.addAll(value.entries.map<
              Map<String, dynamic>>((e) => e.value).toList());
        }
        items = innerList;
      }

      await dbHandler!.insertBulkData(tableName, items);
      return Response(requestOptions: options, data: true, statusCode: 200);
    }

    return Response(
        requestOptions: options,
        data: false,
        statusCode: 405,
        statusMessage: 'Method Not Allowed');
  }
}
