import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/subjects.dart';
import 'package:sample_latest/analytics_exception_handler/custom_exception.dart';
import 'package:sample_latest/analytics_exception_handler/error_logging.dart';
import 'package:sample_latest/analytics_exception_handler/exception_handler.dart';
import 'package:sample_latest/services/base_service.dart';
import 'package:sample_latest/services/db/db_configuration.dart';
import 'package:sample_latest/models/service/queue_item.dart';
import 'package:sample_latest/services/urls.dart';
import 'package:sample_latest/services/utils/db_constants.dart';
import 'package:sample_latest/services/utils/service_enums_typedef.dart';
import 'package:sample_latest/global_variables.dart';
import 'package:sample_latest/mixins/helper_methods.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sample_latest/extensions/dio_request_extension.dart';
import 'package:sample_latest/services/db/db_handler.dart';

export 'package:sample_latest/services/db/offline_handler.dart';

part  'package:sample_latest/services/db/module_db_handler/common_db_handler.dart';
part  'package:sample_latest/services/db/module_db_handler/schools_db_handler.dart';
part  'package:sample_latest/services/db/module_db_handler/todo_list_db_handler.dart';
part  'package:sample_latest/services/utils/abstract_db_handler.dart';

class OfflineHandler with BaseService {

  factory OfflineHandler() {
    return _singleton;
  }

  static final OfflineHandler _singleton = OfflineHandler._internal();

  OfflineHandler._internal();

  var queueItemsCount = BehaviorSubject<int>.seeded(0);

  /// Handle the request which is from the interceptor
  Future<void> handleRequest(RequestOptions options, dynamic handler) async {
    String path = options.path;
    Response? response;

    try {
      if (path.contains(Urls.schools) || path.contains(Urls.schoolDetails) || path.contains(Urls.students)) {
         handler.resolve(await _SchoolsDbHandler().performCrudOperation(options));
      } else if (path.contains(Urls.todoList)) {
         handler.resolve(await _TodoListDbHandler().performCrudOperation(options));
      } else {
         handler.reject(DioException(requestOptions: options, type: DioExceptionType.unknown, error:  OfflineException(), message: DbConstants.notSupportedOfflineErrorMsg));
      }
    } catch (e, s) {
      if(e is DioException){
        handler.reject(e);
      }else {
        handler.reject(DioException(requestOptions: options,
            type: DioExceptionType.unknown,
            message: DbConstants.failedToProcessInOfflineErrorMsg,
            error: OfflineException(error: e, stackTrace: s)));
      }
    } finally {
      await updateQueueItemsCount();
    }
  }

  /// Uploading the queue data to the server
  Future<bool> syncData() async {
    var status = false;

    /// checking whether queue data is present or not
    if (await updateQueueItemsCount() <= 0) return status;

    var queueItems = <QueueItem>[];

    /// Fetching queue items from local DB
    Response queueItemsResponse = await _CommonDbHandler().performCrudOperation(RequestOptions(method: RequestType.get.name, path: DbConstants.queueItems));

    for (var a in queueItemsResponse.data) {
      var queueItem = Map<String, dynamic>.from(a);
      if (queueItem['body'] != null) queueItem['body'] = jsonDecode(queueItem['body']);
      queueItem['queryParams'] = jsonDecode(queueItem['queryParams']);
      queueItems.add(QueueItem.fromJson(queueItem));
    }

    /// Sorting the queue items based on the priority order
    queueItems.sort(
      (a, b) {
        if (a.queueId == -1 || a.queueId! > b.queueId!) return 1;
        return -1;
      },
    );

    navigatorKey.currentContext?.loaderOverlay.show();

    /// Uploading the queue items one by one to the server
    for (var queueItem in queueItems) {
      var requestType = HelperMethods.enumFromString(RequestType.values, queueItem.methodType.toLowerCase());

      try {
        var result = await makeRequest(url: queueItem.path, method: requestType ?? RequestType.get, body: queueItem.body, queryParameters: queueItem.queryParams, isFromQueue: true);

        /// Deleting item from queue table
        if (queueItem.queueId != null) await _CommonDbHandler().deleteQueueItem(queueItem.queueId!);

        /// Deleting items from school db
       if(DbConfigurationsByDev.deleteOfflineDataOnceSuccess) await _SchoolsDbHandler().performCrudOperation(RequestOptions(path: queueItem.path, method: RequestType.delete.name, queryParameters: {DbConstants.idColumnName: queueItem.id.toString()}, extra: {DbConstants.notRequiredToStoreInQueue: true}));

      } catch (e, s) {
        ExceptionHandler().handleException(e, s);
      } finally {
        updateQueueItemsCount();
        navigatorKey.currentContext?.loaderOverlay.hide();
      }
    }

    return status;
  }

  /// Store offline data from the server
  Future<bool> dumpOfflineData() async {
    var status = false;
    try {
      if ((await updateQueueItemsCount()) > 0) await syncData();

      navigatorKey.currentContext?.loaderOverlay.show();

      /// Fetching school information
      var schools = await makeRequest(url: '${Urls.schools}.json', isOfflineApi: false);

      if (schools != null) {
        await _SchoolsDbHandler().performCrudOperation(RequestOptions(path: Urls.schools, method: RequestType.store.name, data: schools));
      }

      /// Fetching school details
      var schoolDetailsList = await makeRequest(url: '${Urls.schoolDetails}.json', isOfflineApi: false);
      if (schoolDetailsList != null) {
        await _SchoolsDbHandler().performCrudOperation(RequestOptions(path: Urls.schoolDetails, method: RequestType.store.name, data: schoolDetailsList));
      }

      /// Fetching student information
      var students = await makeRequest(url: '${Urls.students}.json', isOfflineApi: false);
      if (students != null) {
        await _SchoolsDbHandler().performCrudOperation(RequestOptions(path: Urls.students, method: RequestType.store.name, data: students));
      }

      status = true;
    } catch (e, s) {
      status = false;
    } finally {
      navigatorKey.currentContext?.loaderOverlay.hide();
    }

    return status;
  }

  /// Update the Queue item count in UI
  Future<int> updateQueueItemsCount() async {
    var count = 0;
    try {
      count = await _CommonDbHandler().queueItemsCount();
      queueItemsCount.add(count);
    } catch (e, s) {
      ReportError.errorLog(e, s);
    }finally{
      deleteOutDatedData();
    }
    return count;
  }

  Future<void> deleteOutDatedData() async {

    if(DbConfigurationsByDev.isOutDatedDataNeedsToBeDeleted && (DbConfigurationsByDev.lastDeletedOutDataDate == null ||
        DateTime.now().difference(DbConfigurationsByDev.lastDeletedOutDataDate!).inDays > DbConfigurationsByDev.howLongDataShouldPersist)){
      var date = DateTime.now().subtract(Duration(days: DbConfigurationsByDev.howLongDataShouldPersist)).millisecondsSinceEpoch;
      await _SchoolsDbHandler().deleteOutdatedData(date);
      // await _TodoListDbHandler().deleteOutdatedData(date);
      DbConfigurationsByDev.lastDeletedOutDataDate = DateTime.now();
      await DbConfigurationsByDev.set(DbConfigurationsByDev.lastDeletedOutDataDate!);
      debugPrint('Deleted outdated data');
    }
  }

  ///
 Future<void> eraseAllDatabaseData() async {
   await  _SchoolsDbHandler().resetDataBase();
   await _CommonDbHandler().resetDataBase();
   await _TodoListDbHandler().resetDataBase();
   debugPrint('Erased all the data');
 }
}
