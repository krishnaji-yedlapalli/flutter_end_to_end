
part of 'package:sample_latest/services/db/offline_handler.dart';


abstract class DbHandler {

  bool isDbInitialized = false;

  late SqfLiteDbHandler _dbHandler;

  Future<bool> initializeDb(DbInfo dbInfo) async {
    if(!isDbInitialized) {
      _dbHandler = await SqfLiteDbHandler.initializeDb(dbInfo);
      isDbInitialized = true;
    }
    return true;
  }

  RequestType requestType(String requestType) {
    return HelperMethods.enumFromString(
        RequestType.values, requestType.toLowerCase()) ?? RequestType.get;
  }

  Future<bool> initializeDbIfNot();

  Future<Response> performCrudOperation(RequestOptions options);

  Future<Response> performPostOperation(RequestOptions options);

  Future<Response> performGetOperation(RequestOptions options);

  Future<Response> performDeleteOperation(RequestOptions options);

  Future<Response> performPatchOperation(RequestOptions options);

  Future<Response> performBulkLocalDataStoreOperation(RequestOptions options);

  Future<bool> deleteOutdatedData(int millisecondsSinceEpoch);

  Future<bool> resetDataBase();
}
