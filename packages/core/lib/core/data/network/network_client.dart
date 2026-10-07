import 'package:app_core/core/data/network/network_failure.dart';
import 'package:app_core/core/data/network/network_response.dart';
import 'package:app_core/core/data/strategy/base_url_strategy.dart';
import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

/// Abstract network client interface registered in GetIt.
///
/// All network calls return [Either<NetworkFailure, NetworkResponse<T>>]
/// so that callers handle success and failure explicitly without try-catch.
abstract class NetworkClient {
  /// Makes a typed HTTP request.
  ///
  /// [url] - The request path (transformed by BaseUrlStrategy).
  /// [method] - HTTP method (GET, POST, PUT, PATCH, DELETE).
  /// [decoder] - Optional function to decode the response JSON into type T.
  /// [body] - Request body for POST/PUT/PATCH.
  /// [queryParameters] - URL query parameters.
  /// [headers] - Per-request headers (merged with defaults).
  /// [baseUrl] - Override the default base URL for this request.
  /// [contentType] - Override content type for this request.
  /// [extras] - Extra parameters passed to interceptors via RequestOptions.extra.
  /// [cancelToken] - Per-request cancel token (combined with global token).
  Future<Either<NetworkFailure, NetworkResponse<T>>> makeRequest<T>({
    required String url,
    RequestType method = RequestType.get,
    T Function(Map<String, dynamic> json)? decoder,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    String? baseUrl,
    String? contentType,
    Map<String, dynamic> extras = const {},
    CancelToken? cancelToken,
  });

  /// Creates a journey-scoped client with optional base URL / strategy overrides.
  ///
  /// [baseUrl] overrides the parent Dio base URL when non-null.
  /// [urlStrategy] overrides the parent path strategy when non-null.
  /// [additionalInterceptors] are appended after the global pipeline.
  /// [overrideInterceptors] replace interceptors in the global pipeline by type.
  /// [excludeInterceptorTypes] omit parent interceptors matching those runtime types.
  NetworkClient createJourneyClient({
    String? baseUrl,
    BaseUrlStrategy? urlStrategy,
    List<Interceptor> additionalInterceptors = const [],
    Map<Type, Interceptor> overrideInterceptors = const {},
    Set<Type> excludeInterceptorTypes = const {},
  });

  /// Cancels all in-flight requests and creates a fresh CancelToken.
  void cancelAllRequests();

  /// Disposes resources held by this client.
  void dispose();
}
