import 'package:app_core/core/data/network/network_client.dart';
import 'package:app_core/core/data/network/network_failure.dart';
import 'package:app_core/core/data/network/network_response.dart';
import 'package:app_core/core/data/strategy/base_url_strategy.dart';
import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

/// Concrete implementation of [NetworkClient] backed by Dio.
///
/// Key invariants:
/// - Never mutates `dio.options` after initialization.
/// - Passes per-request Options on every call.
/// - Returns Either<NetworkFailure, NetworkResponse<T>> from every call.
class NetworkClientImpl implements NetworkClient {
  final Dio _dio;
  final BaseUrlStrategy _urlStrategy;
  CancelToken _globalCancelToken;
  final List<Interceptor> _interceptors;

  NetworkClientImpl({
    required Dio dio,
    required BaseUrlStrategy urlStrategy,
  })  : _dio = dio,
        _urlStrategy = urlStrategy,
        _globalCancelToken = CancelToken(),
        _interceptors = List.unmodifiable(dio.interceptors);

  @override
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
  }) async {
    try {
      final effectiveBaseUrl = baseUrl ?? _dio.options.baseUrl;
      final transformedPath = _urlStrategy.transformPath(url, effectiveBaseUrl);

      // Build per-request options — never mutate dio.options
      final options = Options(
        method: _methodString(method),
        headers: headers,
        contentType: contentType,
        extra: Map<String, dynamic>.from(extras),
      );

      // Combine global and per-request cancel tokens
      final CancelToken effectiveCancelToken = cancelToken != null
          ? _CombinedCancelToken(_globalCancelToken, cancelToken)
          : _globalCancelToken;

      final response = await _dio.request<dynamic>(
        transformedPath,
        data: body,
        queryParameters: queryParameters,
        options: options,
        cancelToken: effectiveCancelToken,
      );

      // Decode response
      final T decodedData;
      try {
        if (decoder != null && response.data is Map<String, dynamic>) {
          decodedData = decoder(response.data as Map<String, dynamic>);
        } else {
          decodedData = response.data as T;
        }
      } catch (e) {
        return Left(NetworkFailure(
          type: DataErrorStateType.somethingWentWrong,
          message: 'Failed to decode response: ${e.toString()}',
        ));
      }

      // Build typed response headers
      final responseHeaders = <String, List<String>>{};
      response.headers.forEach((name, values) {
        responseHeaders[name] = values;
      });

      return Right(NetworkResponse<T>(
        data: decodedData,
        statusCode: response.statusCode ?? 200,
        headers: responseHeaders,
      ));
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(NetworkFailure(
        type: DataErrorStateType.somethingWentWrong,
        message: e.toString(),
      ));
    }
  }

  @override
  NetworkClient createJourneyClient({
    List<Interceptor> additionalInterceptors = const [],
    Map<Type, Interceptor> overrideInterceptors = const {},
  }) {
    final journeyDio = Dio(_dio.options.copyWith());

    // Build pipeline: apply overrides to global interceptors, then append additional
    for (final interceptor in _interceptors) {
      final overrideType = interceptor.runtimeType;
      if (overrideInterceptors.containsKey(overrideType)) {
        journeyDio.interceptors.add(overrideInterceptors[overrideType]!);
      } else {
        journeyDio.interceptors.add(interceptor);
      }
    }
    journeyDio.interceptors.addAll(additionalInterceptors);

    return NetworkClientImpl(
      dio: journeyDio,
      urlStrategy: _urlStrategy,
    );
  }

  @override
  void cancelAllRequests() {
    _globalCancelToken.cancel('All requests cancelled');
    _globalCancelToken = CancelToken();
  }

  @override
  void dispose() {
    cancelAllRequests();
    _dio.close();
  }

  /// Maps a [DioException] to a typed [NetworkFailure].
  NetworkFailure _mapDioException(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      return const NetworkFailure(
        type: DataErrorStateType.somethingWentWrong,
        isCancellation: true,
        message: 'Request cancelled',
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkFailure(
          type: DataErrorStateType.timeoutException,
          message: e.message,
        );
      case DioExceptionType.connectionError:
        return NetworkFailure(
          type: DataErrorStateType.noInternet,
          message: e.message,
        );
      case DioExceptionType.badResponse:
        return _mapBadResponse(e);
      case DioExceptionType.cancel:
        return const NetworkFailure(
          type: DataErrorStateType.somethingWentWrong,
          isCancellation: true,
        );
      default:
        return NetworkFailure(
          type: DataErrorStateType.somethingWentWrong,
          message: e.message,
        );
    }
  }

  /// Maps bad HTTP responses to specific error types.
  NetworkFailure _mapBadResponse(DioException e) {
    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 401:
      case 403:
        return NetworkFailure(
          type: DataErrorStateType.unauthorized,
          message: e.message,
        );
      case 500:
      case 502:
        return NetworkFailure(
          type: DataErrorStateType.serverNotFound,
          message: e.message,
        );
      default:
        return NetworkFailure(
          type: DataErrorStateType.somethingWentWrong,
          message: e.message,
        );
    }
  }

  /// Converts [RequestType] enum to the HTTP method string.
  String _methodString(RequestType method) {
    switch (method) {
      case RequestType.get:
        return 'GET';
      case RequestType.post:
        return 'POST';
      case RequestType.put:
        return 'PUT';
      case RequestType.patch:
        return 'PATCH';
      case RequestType.delete:
        return 'DELETE';
      case RequestType.store:
        return 'POST';
    }
  }
}

/// Combines two cancel tokens — cancels the request if either triggers.
///
/// Implemented by listening to the first token and cancelling the second
/// (Dio only accepts one CancelToken per request, so we chain them).
class _CombinedCancelToken extends CancelToken {
  _CombinedCancelToken(CancelToken global, CancelToken perRequest) {
    // If global is already cancelled, cancel immediately
    if (global.isCancelled) {
      cancel(global.cancelError?.message ?? 'Global cancel');
      return;
    }
    if (perRequest.isCancelled) {
      cancel(perRequest.cancelError?.message ?? 'Per-request cancel');
      return;
    }

    // Listen for cancellation from either token
    global.whenCancel.then((_) {
      if (!isCancelled) cancel(global.cancelError?.message ?? 'Global cancel');
    });
    perRequest.whenCancel.then((_) {
      if (!isCancelled) {
        cancel(perRequest.cancelError?.message ?? 'Per-request cancel');
      }
    });
  }
}
