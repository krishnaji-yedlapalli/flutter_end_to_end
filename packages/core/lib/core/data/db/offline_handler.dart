import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rxdart/subjects.dart';
import 'package:app_core/analytics_exception_handler/custom_exception.dart';
import 'package:app_core/analytics_exception_handler/error_reporting.dart';
import 'package:app_core/analytics_exception_handler/exception_handler.dart';
import 'package:app_core/core/data/db/db_config_repository.dart';
import 'package:app_core/core/data/db/db_handler_registry.dart';
import 'package:app_core/core/data/db/dumping_offline_data.dart';
import 'package:app_core/core/data/db/module_db_handler/common_db_handler.dart';
import 'package:app_core/core/data/models/queue_item/queue_item.dart';
import 'package:app_core/core/data/network/network_client.dart';
import 'package:app_core/core/data/utils/db_constants.dart';
import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import 'package:app_core/core/mixins/helper_methods.dart';
import 'package:app_core/core/routing/routing_exports.dart';
import 'package:app_core/core/utils/enums_type_def.dart';

class OfflineHandler {
  late DbHandlerRegistry _registry;

  var queueItemsCount = BehaviorSubject<int>.seeded(0);
  var dumpingOfflineDataStatus =
      BehaviorSubject<OfflineDumpingStatus>.seeded(null);

  /// Initialize the registry — call this at app startup
  void initialize(DbHandlerRegistry registry) {
    _registry = registry;
  }

  DbConfigRepository get _dbConfig => GetIt.instance<DbConfigRepository>();

  /// Handle the request which is from the interceptor
  Future<void> handleRequest(RequestOptions options, dynamic handler) async {
    String path = options.path;

    try {
      var dbHandler = _registry.findHandler(path);
      if (dbHandler != null) {
        handler.resolve(await dbHandler.performCrudOperation(options));
      } else {
        handler.reject(DioException(
            requestOptions: options,
            type: DioExceptionType.unknown,
            error: OfflineException(),
            message: DbConstants.notSupportedOfflineErrorMsg));
      }
    } catch (e, s) {
      if (e is DioException) {
        handler.reject(e);
      } else {
        handler.reject(DioException(
            requestOptions: options,
            type: DioExceptionType.unknown,
            message: DbConstants.failedToProcessInOfflineErrorMsg,
            error: OfflineException(error: e, stackTrace: s)));
      }
    } finally {
      await updateQueueItemsCount();
    }
  }

  /// Store data locally without resolving the handler (used for online+offline mode)
  Future<void> storeLocally(RequestOptions options) async {
    try {
      var dbHandler = _registry.findHandler(options.path);
      if (dbHandler != null) {
        await dbHandler.performCrudOperation(options);
      }
    } catch (e, s) {
      ReportError.errorLog(e, s);
    }
  }

  /// Uploading the queue data to the server
  Future<bool> syncData() async {
    var status = false;

    /// checking whether queue data is present or not
    if (await updateQueueItemsCount() <= 0) return status;

    var queueItems = <QueueItem>[];

    /// Fetching queue items from local DB
    Response queueItemsResponse = await CommonDbHandler().performCrudOperation(
        RequestOptions(
            method: RequestType.get.name, path: DbConstants.queueItems));

    for (var a in queueItemsResponse.data) {
      var queueItem = Map<String, dynamic>.from(a);
      if (queueItem['body'] != null) {
        queueItem['body'] = jsonDecode(queueItem['body']);
      }
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

    NavigationKeys.navigatorKey.currentContext?.loaderOverlay.show();

    /// Uploading the queue items one by one to the server
    for (var queueItem in queueItems) {
      var requestType = HelperMethods.enumFromString(
          RequestType.values, queueItem.methodType.toLowerCase());

      try {
        await GetIt.instance<NetworkClient>().makeRequest(
            url: queueItem.path,
            method: requestType ?? RequestType.get,
            body: queueItem.body,
            queryParameters: queueItem.queryParams,
            extras: {DbConstants.isFromQueue: true});

        /// Deleting item from queue table
        if (queueItem.queueId != null) {
          await CommonDbHandler().deleteQueueItem(queueItem.queueId!);
        }

        /// Deleting items from offline db
        if (_dbConfig.state.deleteOfflineDataOnceSuccess) {
          var handler = _registry.findHandler(queueItem.path);
          if (handler != null) {
            await handler.performCrudOperation(RequestOptions(
                path: queueItem.path,
                method: RequestType.delete.name,
                queryParameters: {
                  DbConstants.idColumnName: queueItem.id.toString()
                },
                extra: {
                  DbConstants.notRequiredToStoreInQueue: true
                }));
          }
        }
      } catch (e, s) {
        ExceptionHandler().handleException(e, s);
      } finally {
        updateQueueItemsCount();
        NavigationKeys.navigatorKey.currentContext?.loaderOverlay.hide();
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
      dumpingOfflineDataStatus
          .add((title: 'Checking for Existing Sync Data...', percentage: 0));

      if ((await updateQueueItemsCount()) > 0) await syncData();

      dumpingOfflineDataStatus
          .add((title: 'Loading Zip File.......', percentage: 10));

      RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
      var completer = Completer();

      /// Loading Zip Data
      ByteData byteData = await rootBundle.load("asset/school_data.zip");

      await Isolate.spawn(DumpingOfflineData.dumpOfflineData,
          [receivePort.sendPort, rootIsolateToken, byteData]);

      /// Listening to the Dumping status
      receivePort.listen((message) {
        if (message == 'success') {
          completer.complete();
        } else {
          dumpingOfflineDataStatus
              .add((title: message.title, percentage: message.percentage));
        }
      });

      /// Once data dumping is success or failure this future is completed
      await completer.future;

      dumpingOfflineDataStatus
          .add((title: 'Successfully Dumped.......', percentage: 100));
      await Future.delayed(const Duration(seconds: 1));

      /// Delay is added for better experience
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
      count = await CommonDbHandler().queueItemsCount();
      queueItemsCount.add(count);
    } catch (e, s) {
      ReportError.errorLog(e, s);
    } finally {
      deleteOutDatedData();
    }
    return count;
  }

  Future<void> deleteOutDatedData() async {
    var config = _dbConfig.state;
    if (config.isOutDatedDataNeedsToBeDeleted &&
        (config.lastDeletedOutDataDate == null ||
            DateTime.now().difference(config.lastDeletedOutDataDate!).inDays >
                config.howLongDataShouldPersist)) {
      var date = DateTime.now()
          .subtract(Duration(days: config.howLongDataShouldPersist))
          .millisecondsSinceEpoch;

      /// Delete outdated data from all registered handlers
      for (var handler in _registry.allHandlers) {
        await handler.deleteOutdatedData(date);
      }

      await _dbConfig.persistLastDeletedDate(DateTime.now());
      debugPrint('Deleted outdated data');
    }
  }

  /// Erase all database data
  Future<void> eraseAllDatabaseData() async {
    for (var handler in _registry.allHandlers) {
      await handler.resetDataBase();
    }
    await CommonDbHandler().resetDataBase();
    debugPrint('Erased all the data');
  }
}
