import 'package:app_core/core/data/token/token_storage.dart';
import 'package:dio/dio.dart';

/// Attaches JWT Bearer token to every authenticated request.
///
/// Skips token attachment when:
/// - `skipAuth: true` is set in request extras
/// - No token exists in storage
/// - Token read fails (fail-safe: proceeds without header)
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  AuthInterceptor(this._tokenStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] == true) {
      return handler.next(options);
    }

    try {
      final token = await _tokenStorage.readAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Token read failed — proceed without auth header (fail-safe)
    }

    handler.next(options);
  }
}
