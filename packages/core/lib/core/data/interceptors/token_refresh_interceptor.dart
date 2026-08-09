import 'package:dio/dio.dart';
import 'package:app_core/core/data/token/token_storage.dart';

/// Handles 401 responses by refreshing the token and retrying queued requests.
///
/// Uses [QueuedInterceptorsWrapper] to serialize token refresh attempts so that
/// only one refresh happens at a time — concurrent 401s queue behind it.
class TokenRefreshInterceptor extends QueuedInterceptorsWrapper {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio;
  final String _refreshEndpoint;
  // ignore: unused_field
  final int _maxQueueSize;
  final Duration _refreshTimeout;

  /// Key used to mark a request as already retried (prevents infinite loops).
  static const _retryKey = '_tokenRefreshRetried';

  TokenRefreshInterceptor({
    required TokenStorage tokenStorage,
    required Dio refreshDio,
    required String refreshEndpoint,
    int maxQueueSize = 50,
    Duration refreshTimeout = const Duration(seconds: 10),
  })  : _tokenStorage = tokenStorage,
        _refreshDio = refreshDio,
        _refreshEndpoint = refreshEndpoint,
        _maxQueueSize = maxQueueSize,
        _refreshTimeout = refreshTimeout;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;

    // If this request has already been retried after a refresh, reject it.
    if (requestOptions.extra[_retryKey] == true) {
      return handler.reject(err);
    }

    // Attempt token refresh
    try {
      final refreshToken = await _tokenStorage.readRefreshToken();

      // No refresh token available — reject immediately
      if (refreshToken == null) {
        await _tokenStorage.deleteAll();
        return handler.reject(err);
      }

      // Call refresh endpoint using a separate Dio (avoids interceptor recursion)
      final response = await _refreshDio.post(
        _refreshEndpoint,
        data: {'refresh_token': refreshToken},
        options: Options(
          sendTimeout: _refreshTimeout,
          receiveTimeout: _refreshTimeout,
        ),
      );

      final newAccessToken = response.data['access_token'] as String?;
      final newRefreshToken = response.data['refresh_token'] as String?;

      if (newAccessToken == null) {
        await _tokenStorage.deleteAll();
        return handler.reject(err);
      }

      // Store new tokens
      await _tokenStorage.writeAccessToken(newAccessToken);
      if (newRefreshToken != null) {
        await _tokenStorage.writeRefreshToken(newRefreshToken);
      }

      // Retry the original request with the new token
      requestOptions.extra[_retryKey] = true;
      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      final retryResponse = await _refreshDio.fetch(requestOptions);
      return handler.resolve(retryResponse);
    } on DioException catch (_) {
      // Refresh failed — clear tokens and reject
      await _tokenStorage.deleteAll();
      return handler.reject(err);
    } catch (_) {
      // Unexpected error during refresh — clear tokens and reject
      await _tokenStorage.deleteAll();
      return handler.reject(err);
    }
  }
}
