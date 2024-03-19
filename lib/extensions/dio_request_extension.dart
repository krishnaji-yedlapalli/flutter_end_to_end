
import 'package:dio/dio.dart';
import 'package:sample_latest/services/utils/db_constants.dart';

extension DioRequestExtension on RequestOptions {
  
  bool get isOfflineApi => extra.containsKey(DbConstants.isOfflineApi) && extra[DbConstants.isOfflineApi];

  bool get isFromQueueItem => extra.containsKey(DbConstants.isFromQueue) && extra[DbConstants.isFromQueue];

  bool get notRequiredToStoreInQueue => extra.containsKey(DbConstants.notRequiredToStoreInQueue) && extra[DbConstants.notRequiredToStoreInQueue];

  int get priority => extra.containsKey(DbConstants.priority) ? extra[DbConstants.priority] : -1;

  set isOfflineApi(bool status) => extra[DbConstants.isOfflineApi] = status;

  set isFromQueueItem(bool status) => extra[DbConstants.isFromQueue] = status;

  set notRequiredToStoreInQueue(bool status) => extra[DbConstants.notRequiredToStoreInQueue] = status;

  set priority(int status) => extra[DbConstants.priority] = status;
}