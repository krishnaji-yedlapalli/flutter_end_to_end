import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:sample_latest/analytics_exception_handler/custom_exception.dart';
import 'package:sample_latest/analytics_exception_handler/error_reporting.dart';
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
import 'package:sample_latest/utils/enums_type_def.dart';

import '../utils/abstract_db_handler.dart';

export 'package:sample_latest/services/db/offline_handler.dart';
import 'package:flutter/services.dart' show rootBundle;

part  'package:sample_latest/services/db/module_db_handler/common_db_handler.dart';
part  'package:sample_latest/services/db/module_db_handler/schools_db_handler.dart';
part  'package:sample_latest/services/db/module_db_handler/todo_list_db_handler.dart';
part 'dumping_offline_data.dart';

class OfflineHandler {

  factory OfflineHandler() {
    return _singleton;
  }

  static final OfflineHandler _singleton = OfflineHandler._internal();

  OfflineHandler._internal();

  var queueItemsCount = BehaviorSubject<int>.seeded(0);
  var dumpingOfflineDataStatus = BehaviorSubject<OfflineDumpingStatus>.seeded(null);

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
        var result = await BaseService.instance.makeRequest(url: queueItem.path, method: requestType ?? RequestType.get, body: queueItem.body, queryParameters: queueItem.queryParams, isFromQueue: true);

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
    final receivePort = ReceivePort();

    try {
      dumpingOfflineDataStatus.asBroadcastStream();
      dumpingOfflineDataStatus.add((title: 'Checking for Existing Sync Data...', percentage: 0));

      if ((await updateQueueItemsCount()) > 0) await syncData();

      dumpingOfflineDataStatus.add((title: 'Loading Zip File.......', percentage: 10));

      RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
      _SchoolsDbHandler().initializeDbIfNot();
      var completer = Completer();

      /// Loading Zip Data
      ByteData byteData = await rootBundle.load("asset/school_data.zip");


      var res = await Isolate.spawn(_DumpingOfflineData.dumpOfflineData, [receivePort.sendPort, rootIsolateToken, byteData]);

      /// Listening to the Dumping status
      receivePort.listen((message) {
        if(message == 'success'){
          completer.complete();
        }else {
          dumpingOfflineDataStatus.add(
              (title: message.title, percentage: message.percentage));
        }
      });

      /// Once data dumping is success or failure this future is completed
      await completer.future;

      dumpingOfflineDataStatus.add((title: 'Successfully Dumped.......', percentage: 100));
      await Future.delayed(const Duration(seconds: 1)); /// Delay is added for better experience
      status = true;
    } catch (e) {
      status = false;
    } finally {
      dumpingOfflineDataStatus.add(null);
      receivePort.close();
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
