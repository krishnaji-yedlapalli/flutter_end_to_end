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
import 'package:sample_latest/mixins/helper_methods.dart';

class OfflineHandler extends BaseService {
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
    }

    for (var queueItem in queueItems) {
      var requestType = HelperMethods.enumFromString(
          RequestType.values, queueItem.methodType.toLowerCase());

      try {
        var result = makeRequest(
            url: queueItem.path,
            method: requestType ?? RequestType.get,
            body: queueItem.body,
            queryParameters: queueItem.queryParams,
            isOfflineApi: false);

        CommonDbHandler().performDbOperation(RequestOptions(
            path: DbConstants.queueItems,
            method: RequestType.delete.name,
            queryParameters: {DbConstants.idColumnName: queueItem.id}));
      } catch (e, s) {
        ExceptionHandler().handleException(e, s);
      }
    }

    return status;
  }


  Future<void> dumpOfflineData() async {
    try{
      /// Fetching school information
      var schools = await makeRequest(url: Urls.schools);

      SchoolsDbHandler().performDbOperation(options);

      /// Fetching school details
      var schoolDetailsList = await makeRequest(url: Urls.schoolDetails);

      /// Fetching student information
      var students = await makeRequest(url: Urls.students);


    }catch(e,s){

    }
  }
}
