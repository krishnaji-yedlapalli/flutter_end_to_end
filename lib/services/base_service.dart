import 'dart:async';

import 'package:dio/dio.dart';
import 'package:sample_latest/global_variables.dart';
import 'package:sample_latest/services/utils/db_constants.dart';

import 'urls.dart';
import 'utils/service_enums_typedef.dart';

mixin BaseService {
  Future<dynamic> makeRequest<T>(
      {required String url,
      String? baseUrl,
      dynamic body,
      String? contentType,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers,
      RequestType method = RequestType.get,
      Map<String, dynamic> extras = const {}, bool isOfflineApi = true, bool isFromQueue = false}) async {

    dio.options.baseUrl = baseUrl ?? Urls.baseUrl;
    dio.options.extra.addAll(extras);
    dio.options.extra[DbConstants.isOfflineApi] = isOfflineApi;
    dio.options.extra[DbConstants.isFromQueue] = isFromQueue;

    if (headers != null) dio.options.headers.addAll(headers);

    Response response;
    switch (method) {
      case RequestType.get:
        if (queryParameters != null && queryParameters.isNotEmpty) {
          response = await dio.get(
            url,
            queryParameters: queryParameters,
          );
          return response.data;
        }
        response = await dio.get(url);
        return response.data;
      case RequestType.put:
        response =
            await dio.put(url, queryParameters: queryParameters, data: body);
        return response.data;
      case RequestType.post:
        response = await dio.post(
          url,
          queryParameters: queryParameters,
          data: body,
        );
        return response.data;
      case RequestType.delete:
        response =
            await dio.delete(url, queryParameters: queryParameters, data: body);
        return response.data;
      case RequestType.patch:
        response = await dio.patch(
          url,
          queryParameters: queryParameters,
          data: body,
        );
      case RequestType.store:
       throw UnsupportedError('');
    }
    return response.data;
  }

  // Future<dynamic> makeRequest<T>(
  //     {required String url,
  //     String? baseUrl,
  //     Map<String, dynamic>? body,
  //     String? contentType,
  //     Map<String, dynamic>? queryParameters,
  //     Map<String, String>? headers,
  //     RequestType method = RequestType.get,
  //       Map<String, dynamic> extras = const {}, bool storeResponseInDb = false}) async {
  //
  //   var domainUrl = baseUrl ?? Urls.baseUrl;
  //
  //   var uriUrl = Uri.https(Urls.baseUrl, url);
  //
  //   // http.Client client = InterceptedClient.build(interceptors: [
  //   //   Interceptors(),
  //   // ]);
  //
  //   http.Response response;
  //     switch (method) {
  //       case RequestType.get:
  //         if (queryParameters != null && queryParameters.isNotEmpty) {
  //
  //           response = await client.get(
  //             uriUrl,
  //           );
  //           return response;
  //         }
  //
  //         response = await client.get(uriUrl);
  //         return _responseParser(response);
  //       case RequestType.put:
  //         response = await client.put(uriUrl, body: jsonEncode(body));
  //         return _responseParser(response);
  //       case RequestType.patch:
  //         response = await client.patch(uriUrl, body: jsonEncode(body));
  //         return _responseParser(response);
  //       case RequestType.post:
  //         // response = await http.post(
  //         //   url,
  //         //   queryParameters: queryParameters,
  //         //   data: jsonEncode(body),
  //         // );
  //         // return response.data;
  //       case RequestType.delete:
  //         response = await client.delete(uriUrl);
  //         return _responseParser(response);
  //     }
  //   }
  //
  //
  // dynamic _responseParser(http.Response response) {
  //
  //     if(response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
  //       return jsonDecode(response.body);
  //     } else {
  //       throw ServerException(response.statusCode, response);
  //     }
  // }
}
