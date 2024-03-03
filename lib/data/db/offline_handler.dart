import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sample_latest/analytics_exception_handler/error_logging.dart';
import 'package:sample_latest/analytics_exception_handler/exception_handler.dart';
import 'package:sample_latest/data/base_service.dart';
import 'package:sample_latest/data/db/module_db_handler/common_db_handler.dart';
import 'package:sample_latest/data/db/module_db_handler/schools_db_handler.dart';
import 'package:sample_latest/data/db/module_db_handler/todo_list_db_handler.dart';
import 'package:sample_latest/data/models/services/queue_item.dart';
import 'package:sample_latest/data/urls.dart';
import 'package:sample_latest/data/utils/db_constants.dart';
import 'package:sample_latest/data/utils/enums.dart';
import 'package:sample_latest/global_variables.dart';
import 'package:sample_latest/mixins/helper_methods.dart';
import 'package:loader_overlay/loader_overlay.dart';

class OfflineHandler with BaseService {
  factory OfflineHandler() {
    return _singleton;
  }

  static final OfflineHandler _singleton = OfflineHandler._internal();

  OfflineHandler._internal();

  StreamController<int> queueItemsCount = StreamController<int>.broadcast();

  Future<Response> handleRequest(RequestOptions options) async {
    String path = options.path;

    try {
      if (path.contains(Urls.schools) || path.contains(Urls.schoolDetails) || path.contains(Urls.students)) {
        return await SchoolsDbHandler().performDbOperation(options);
      } else if (path.contains(Urls.todoList)) {
        return await TodoListDbHandler().performDbOperation(options);
      } else {
        throw DioException(requestOptions: options, type: DioExceptionType.connectionError);
      }
    } catch (e, s) {
      throw DioException(requestOptions: options, type: DioExceptionType.connectionError);
    } finally {
      await updateQueueItemsCount();
    }
  }

  Future<bool> syncData() async {
    var status = false;

    /// checking whether queue data is present or not
    if (await updateQueueItemsCount() <= 0) return false;

    var queueItems = <QueueItem>[];

    /// Fetching queue items from local DB
    Response queueItemsResponse = await CommonDbHandler().performDbOperation(RequestOptions(method: 'get', path: DbConstants.queueItems));

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
        var result = await makeRequest(url: queueItem.path, method: requestType ?? RequestType.get, body: queueItem.body, queryParameters: queueItem.queryParams, isOfflineApi: false);

        /// Deleting item from queue table
        if (queueItem.queueId != null) await CommonDbHandler().deleteQueueItem(queueItem.queueId!);

        /// Deleting items from school db
        await SchoolsDbHandler().performDbOperation(RequestOptions(path: queueItem.path, method: RequestType.delete.name, queryParameters: {DbConstants.idColumnName: queueItem.id.toString()}, extra: {DbConstants.notRequiredToStoreInQueue: true}));
      } catch (e, s) {
        ExceptionHandler().handleException(e, s);
      } finally {
        updateQueueItemsCount();
        navigatorKey.currentContext?.loaderOverlay.hide();
      }
    }

    return status;
  }

  Future<bool> dumpOfflineData() async {
    var status = false;
    try {
      if ((await updateQueueItemsCount()) > 0) await syncData();

      navigatorKey.currentContext?.loaderOverlay.show();

      /// Fetching school information
      var schools = await makeRequest(url: '${Urls.schools}.json', isOfflineApi: false);

      if (schools != null) {
        await SchoolsDbHandler().performDbOperation(RequestOptions(path: Urls.schools, method: RequestType.store.name, data: schools));
      }

      /// Fetching school details
      var schoolDetailsList = await makeRequest(url: '${Urls.schoolDetails}.json', isOfflineApi: false);
      if (schoolDetailsList != null) {
        await SchoolsDbHandler().performDbOperation(RequestOptions(path: Urls.schoolDetails, method: RequestType.store.name, data: schoolDetailsList));
      }

      /// Fetching student information
      var students = await makeRequest(url: '${Urls.students}.json', isOfflineApi: false);
      if (students != null) {
        await SchoolsDbHandler().performDbOperation(RequestOptions(path: Urls.students, method: RequestType.store.name, data: students));
      }

      status = true;
    } catch (e, s) {
      status = false;
    } finally {
      navigatorKey.currentContext?.loaderOverlay.hide();
    }

    return status;
  }

  Future<int> updateQueueItemsCount() async {
    var count = 0;
    try {
      count = await CommonDbHandler().queueItemsCount();
      queueItemsCount.add(count);
    } catch (e, s) {
      ErrorLogging.errorLog(e, s);
    }
    return count;
  }
}
