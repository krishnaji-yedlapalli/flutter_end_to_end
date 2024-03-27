
part of 'package:sample_latest/services/db/offline_handler.dart';

class _SchoolsDbHandler extends DbHandler {

  _SchoolsDbHandler._internal();

  static final _SchoolsDbHandler _singleton = _SchoolsDbHandler._internal();

  factory _SchoolsDbHandler() {
    return _singleton;
  }

  final DbInfo dbInfo = (dbName: 'school', dbVersion: 5, queryFileName: 'create_school_table_queries');

  @override
  Future<bool> initializeDbIfNot() async {
    return await super.initializeDb(dbInfo);
  }

  @override
  Future<Response> performCrudOperation(RequestOptions options) async {

    await initializeDbIfNot();

      switch (requestType(options.method)) {
        case RequestType.get:
          return performGetOperation(options);
        case RequestType.post:
        case RequestType.patch:
        case RequestType.put:
          return performPatchOperation(options);
        case RequestType.delete:
          return performDeleteOperation(options);
        case RequestType.store:
          return performBulkLocalDataStoreOperation(options);
        default:
          throw DioException(
              requestOptions: options,
              error:  OfflineException(),
              type: DioExceptionType.unknown,
              message : DbConstants.notSupportedOfflineErrorMsg);
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
      int recordId = await _dbHandler.deleteRecord(
          tableName: dbName, columnName: DbConstants.idColumnName, ids: [id]);

      /// Storing the data locally
      if(!(options.extra.containsKey(DbConstants.notRequiredToStoreInQueue) && options.extra[DbConstants.notRequiredToStoreInQueue])) {
        await _CommonDbHandler().insertQueueItem(options);
      }
    } else {
      throw DioException(
          requestOptions: options,
          error:  OfflineException(),
          type: DioExceptionType.unknown,
          message : DbConstants.notSupportedOfflineErrorMsg);
    }

    return Response(requestOptions: options, data: true, statusCode: 200);
  }

  @override
  Future<Response> performGetOperation(RequestOptions options) async {
    if (options.path.contains(Urls.schools)) {
      /// To get the school details
      List<Map<String, dynamic>>? schools =
          await _dbHandler.query(SchoolDbConstants.schoolsTableName);
      return Response(
          requestOptions: options, data: schools ?? [], statusCode: 200);
    } else if (options.path.contains(Urls.schoolDetails)) {
      /// To get the school added details
      List<Map<String, dynamic>>? schoolDetailsList = await _dbHandler.query(
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
        List<Map<String, dynamic>>? students = await _dbHandler.query(
            SchoolDbConstants.studentsTableName,
            columnName: SchoolDbConstants.schoolIdColumnName,
            ids: [paths.last.split('.').first]);
        return Response(
            requestOptions: options, data: students ?? [], statusCode: 200);
      } else {
        /// To get the students based on the school
        List<Map<String, dynamic>>? students = await _dbHandler.query(
            SchoolDbConstants.studentsTableName,
            columnName: DbConstants.idColumnName,
            ids: [paths.last.split('.').first]);
        return Response(
            requestOptions: options, data: students?.first, statusCode: 200);
      }
    }

    throw DioException(
        requestOptions: options,
        error:  OfflineException(),
        type: DioExceptionType.unknown,
        message : DbConstants.notSupportedOfflineErrorMsg);
  }

  @override
  Future<Response> performPatchOperation(RequestOptions options) async {
    String? tableName;

    if (options.path.contains(Urls.schools)) {
      tableName = SchoolDbConstants.schoolsTableName;
      options.priority = 1;
    } else if (options.path.contains(Urls.schoolDetails)) {
      tableName = SchoolDbConstants.schoolDetailsTableName;
      options.priority = 2;
    } else if (options.path.contains(Urls.students)) {
      tableName = SchoolDbConstants.studentsTableName;
      options.priority = 3;
    }

    if (tableName != null) {
      var body = options.data[options.data.keys.first];
      var response = await _dbHandler.insertData(tableName, body);

      /// Storing the data locally
      if(!(options.notRequiredToStoreInQueue)) {
        await _CommonDbHandler().insertQueueItem(options);
      }
      return Response(requestOptions: options, data: options.data, statusCode: 200);
    }

    throw DioException(
        requestOptions: options,
        error:  OfflineException(),
        type: DioExceptionType.unknown,
        message : DbConstants.notSupportedOfflineErrorMsg);
  }

  @override
  Future<Response> performPostOperation(RequestOptions options) {
    // TODO: implement performPostOperation
    throw UnimplementedError();
  }

  @override
  Future<Response> performBulkLocalDataStoreOperation(RequestOptions options) async {
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
      await _dbHandler.deleteTableData(tableName);

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

      await _dbHandler.insertBulkData(tableName, items);
      return Response(requestOptions: options, data: true, statusCode: 200);
    }

    throw DioException(
        requestOptions: options,
        error:  OfflineException(),
        type: DioExceptionType.unknown,
        message : DbConstants.notSupportedOfflineErrorMsg);
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
