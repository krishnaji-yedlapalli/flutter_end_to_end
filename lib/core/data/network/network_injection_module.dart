import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_latest/core/data/cache/cache_config.dart';
import 'package:sample_latest/core/data/interceptors/auth_interceptor.dart';
import 'package:sample_latest/core/data/interceptors/interceptor.dart';
import 'package:sample_latest/core/data/interceptors/ssl_pinning_config.dart';
import 'package:sample_latest/core/data/interceptors/token_refresh_interceptor.dart';
import 'package:sample_latest/core/data/network/network_client.dart';
import 'package:sample_latest/core/data/network/network_client_impl.dart';
import 'package:sample_latest/core/data/strategy/firebase_url_strategy.dart';
import 'package:sample_latest/core/data/token/token_storage.dart';
import 'package:sample_latest/core/data/token/token_storage_impl.dart';
import 'package:sample_latest/core/data/urls.dart';

/// Registers network layer dependencies in GetIt.
///
/// Call [registerDependencies] during app startup.
/// Call [reset] during test teardown to unregister all network dependencies.
class NetworkInjectionModule {
  static Future<void> registerDependencies({
    List<Interceptor>? interceptorOverrides,
  }) async {
    final getIt = GetIt.instance;

    // 1. Register TokenStorage (before NetworkClient, which depends on it)
    getIt.registerLazySingleton<TokenStorage>(
      () => TokenStorageImpl(const FlutterSecureStorage()),
    );

    // 2. Build Dio with BaseOptions (configured once, never mutated)
    final dio = Dio(BaseOptions(
      baseUrl: Urls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    // 3. Configure SSL pinning on Dio's HttpClientAdapter
    await configureSslPinning(dio);

    // 4. Build interceptor pipeline (or use overrides for testing)
    final interceptors = interceptorOverrides ??
        [
          // Only include OfflineInterceptor when offline dependencies are registered
          // (OfflineInjectionModule is skipped on web)
          if (!kIsWeb) RequestBypassInterceptor(),
          AuthInterceptor(getIt<TokenStorage>()),
          TokenRefreshInterceptor(
            // index 2: Token Refresh
            tokenStorage: getIt<TokenStorage>(),
            refreshDio: Dio(), // clean Dio for refresh calls
            refreshEndpoint: '/auth/refresh',
          ),
          buildCacheInterceptor(), // index 3: Cache
        ];
    dio.interceptors.addAll(interceptors);

    // 5. Register NetworkClient as lazy singleton against the abstract type
    getIt.registerLazySingleton<NetworkClient>(
      () => NetworkClientImpl(
        dio: dio,
        urlStrategy: FirebaseUrlStrategy(),
      ),
    );
  }

  /// Unregisters network dependencies for test teardown.
  static Future<void> reset() async {
    final getIt = GetIt.instance;
    if (getIt.isRegistered<NetworkClient>()) {
      getIt.unregister<NetworkClient>();
    }
    if (getIt.isRegistered<TokenStorage>()) {
      getIt.unregister<TokenStorage>();
    }
  }
}
