import 'dart:convert';

import 'package:dio/dio.dart';
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

  Future<Response> handleRequest(RequestOptions options) async {
    String path = options.path;

    try {
      if (path.contains(Urls.schools) ||
          path.contains(Urls.schoolDetails) ||
          path.contains(Urls.students)) {
        return await SchoolsDbHandler().performDbOperation(options);
      } else if (path.contains(Urls.todoList)) {
        return await TodoListDbHandler().performDbOperation(options);
      } else {
        throw DioException(
            requestOptions: options, type: DioExceptionType.connectionError);
      }
    } catch (e, s) {
      throw DioException(
          requestOptions: options, type: DioExceptionType.connectionError);
    }
  }

  Future<bool> syncData() async {
    var status = false;

    var queueItems = <QueueItem>[];
    Response response = await CommonDbHandler().performDbOperation(
        RequestOptions(method: 'get', path: DbConstants.queueItems));

    if (response.data != null &&
        response.data is List &&
        response.data.isNotEmpty) {
      for (var a in response.data) {
        var queueItem = Map<String, dynamic>.from(a);
        queueItem['body'] = jsonDecode(queueItem['body']);
        queueItem['queryParams'] = jsonDecode(queueItem['queryParams']);
        queueItems.add(QueueItem.fromJson(queueItem));
      }
    }else{
      return false;
    }

    navigatorKey.currentContext?.loaderOverlay.show();

    for (var queueItem in queueItems) {
      var requestType = HelperMethods.enumFromString(
          RequestType.values, queueItem.methodType.toLowerCase());

      try {
        var result = await makeRequest(
            url: queueItem.path,
            method: requestType ?? RequestType.get,
            body: queueItem.body,
            queryParameters: queueItem.queryParams,
            isOfflineApi: false);

        await CommonDbHandler().performDbOperation(RequestOptions(
            path: DbConstants.queueItems,
            method: RequestType.delete.name,
            queryParameters: {DbConstants.idColumnName: queueItem.id.toString()}));
      } catch (e, s) {
        ExceptionHandler().handleException(e, s);
      }finally{
        navigatorKey.currentContext?.loaderOverlay.hide();
      }
    }

    return status;
  }

  Future<void> dumpOfflineData() async {
    try {

      navigatorKey.currentContext?.loaderOverlay.show();

      /// Fetching school information
      var schools = await makeRequest(url: '${Urls.schools}.json', isOfflineApi: false);

      if(schools != null) {
        await SchoolsDbHandler().performDbOperation(RequestOptions(
          path: Urls.schools, method: RequestType.store.name, data: schools));
      }

      /// Fetching school details
      var schoolDetailsList = await makeRequest(url: '${Urls.schoolDetails}.json', isOfflineApi: false);
     if(schoolDetailsList != null) {
       await SchoolsDbHandler().performDbOperation(RequestOptions(
          path: Urls.schoolDetails,
          method: RequestType.store.name,
          data: schoolDetailsList));
     }

      /// Fetching student information
      var students = await makeRequest(url: '${Urls.students}.json', isOfflineApi: false);
     if(students != null) {
       await SchoolsDbHandler().performDbOperation(RequestOptions(
          path: Urls.students, method: RequestType.store.name, data: students));
     }
    } catch (e, s) {
      print('error');
    }finally{
      navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }
}
