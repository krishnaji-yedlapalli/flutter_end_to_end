import 'package:dio/dio.dart';
import 'package:sample_latest/services/utils/db_constants.dart';

extension DioRequestExtension on RequestOptions {

  /// To check whether this Api supports Offline or not
  bool get isOfflineApi => extra.containsKey(DbConstants.isOfflineApi) && extra[DbConstants.isOfflineApi];

  ///To check whether this request is Queue items
  bool get isFromQueueItem => extra.containsKey(DbConstants.isFromQueue) && extra[DbConstants.isFromQueue];

  ///Whether this request is required to store in local db or not
  bool get notRequiredToStoreInQueue => extra.containsKey(DbConstants.notRequiredToStoreInQueue) && extra[DbConstants.notRequiredToStoreInQueue];

  /// Get the Priority or else default is -1
  int get priority => extra.containsKey(DbConstants.priority) ? extra[DbConstants.priority] : -1;

  /// For setting the flag value of is Offline support or not
  set isOfflineApi(bool status) => extra[DbConstants.isOfflineApi] = status;

  /// Setter to set the is From Queue item or not
  set isFromQueueItem(bool status) => extra[DbConstants.isFromQueue] = status;

  /// Setter to set the status of whether to store in Queue or not
  set notRequiredToStoreInQueue(bool status) => extra[DbConstants.notRequiredToStoreInQueue] = status;

  /// Setter to set the priority
  set priority(int status) => extra[DbConstants.priority] = status;
}