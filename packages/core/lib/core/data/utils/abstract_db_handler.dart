import 'package:app_core/core/data/db/db_handler.dart';
import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import 'package:app_core/core/mixins/helper_methods.dart';
import 'package:dio/dio.dart';

abstract class DbHandler {
  bool isDbInitialized = false;

  late SqfLiteDbHandler _dbHandler;

  SqfLiteDbHandler get dbHandler {
    return _dbHandler;
  }

  Future<bool> initializeDb(DbInfo dbInfo) async {
    if (!isDbInitialized) {
      _dbHandler = await SqfLiteDbHandler.initializeDb(dbInfo);
      isDbInitialized = true;
    }
    return true;
  }

  RequestType requestType(String requestType) {
    return HelperMethods.enumFromString(
            RequestType.values, requestType.toLowerCase()) ??
        RequestType.get;
  }

  Future<bool> initializeDbIfNot();

  List<String> get supportedPaths;

  Future<Response> performCrudOperation(RequestOptions options);

  Future<Response> performPostOperation(RequestOptions options);

  Future<Response> performGetOperation(RequestOptions options);

  Future<Response> performDeleteOperation(RequestOptions options);

  Future<Response> performPatchOperation(RequestOptions options);

  Future<Response> performBulkLocalDataStoreOperation(RequestOptions options);

  Future<bool> deleteOutdatedData(int millisecondsSinceEpoch);

  Future<bool> resetDataBase();
}
