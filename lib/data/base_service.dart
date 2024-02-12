import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../utils/enums.dart';
import 'urls.dart';

class BaseService {
  Future<dynamic> makeRequest<T>(
      {required String url,
      String? baseUrl,
      Map<String, dynamic>? body,
      String? contentType,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers,
      RequestType method = RequestType.get,
        Map<String, dynamic> extras = const {}, bool storeResponseInDb = false}) async {

    var domainUrl = baseUrl ?? Urls.baseUrl;
    // dio.options.headers[HttpHeaders.contentTypeHeader] = 'text/xml';
    // dio.options.extra.addAll(extras);
    // dio.options.extra['storeResponse'] = storeResponseInDb;
    // if(headers != null) dio.options.headers.addAll(headers);
    var uriUrl = Uri.https(Urls.baseUrl, url);
    http.Response response;
      switch (method) {
        case RequestType.get:
          if (queryParameters != null && queryParameters.isNotEmpty) {

            response = await http.get(
              uriUrl,
            );
            return response;
          }

          response = await http.get(uriUrl);
          return jsonDecode(response.body);
        case RequestType.put:
          response = await http.put(uriUrl, body: jsonEncode(body));
          return jsonDecode(response.body);
        case RequestType.patch:
          response = await http.patch(uriUrl, body: jsonEncode(body));
          return jsonDecode(response.body);
        case RequestType.post:
          // response = await http.post(
          //   url,
          //   queryParameters: queryParameters,
          //   data: jsonEncode(body),
          // );
          // return response.data;
        case RequestType.delete:
          response = await http.delete(uriUrl);
          return jsonDecode(response.body);
      }
    }
  }
