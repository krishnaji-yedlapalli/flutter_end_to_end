import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:sample_latest/data/interceptors/interceptor.dart';

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

    http.Client client = InterceptedClient.build(interceptors: [
      Interceptors(),
    ]);

    var uriUrl = Uri.https(Urls.baseUrl, url);
    http.Response response;
      switch (method) {
        case RequestType.get:
          if (queryParameters != null && queryParameters.isNotEmpty) {

            response = await client.get(
              uriUrl,
            );
            return response;
          }

          response = await client.get(uriUrl);
          return jsonDecode(response.body);
        case RequestType.put:
          response = await client.put(uriUrl, body: jsonEncode(body));
          return jsonDecode(response.body);
        case RequestType.patch:
          response = await client.patch(uriUrl, body: jsonEncode(body));
          return jsonDecode(response.body);
        case RequestType.post:
          // response = await http.post(
          //   url,
          //   queryParameters: queryParameters,
          //   data: jsonEncode(body),
          // );
          // return response.data;
        case RequestType.delete:
          response = await client.delete(uriUrl);
          return jsonDecode(response.body);
      }
    }
  }
