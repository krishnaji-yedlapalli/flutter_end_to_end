import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:app_core/core/data/cache/cache_config.dart';
import 'package:app_core/core/data/interceptors/auth_interceptor.dart';
import 'package:app_core/core/data/interceptors/interceptor.dart';
import 'package:app_core/core/data/interceptors/ssl_pinning.dart';
import 'package:app_core/core/data/interceptors/ssl_pinning_config.dart';
import 'package:app_core/core/data/interceptors/token_refresh_interceptor.dart';
import 'package:app_core/core/data/network/network_client.dart';
import 'package:app_core/core/data/network/network_client_impl.dart';
import 'package:app_core/core/data/strategy/firebase_url_strategy.dart';
import 'package:app_core/core/data/strategy/passthrough_url_strategy.dart';
import 'package:app_core/core/data/token/token_storage.dart';
import 'package:app_core/core/data/token/token_storage_impl.dart';
import 'package:app_core/core/data/urls.dart';

/// GetIt instance names for named NetworkClient registrations.
abstract class NetworkClientName {
  /// Default client — Azure App Service (.NET API).
  static const String azure = 'azure';

  /// Firebase Realtime Database client.
  static const String firebase = 'firebase';
}

/// Registers network layer dependencies in GetIt.
///
/// Two named [NetworkClient] instances are registered:
///   - [NetworkClientName.azure]    → Azure App Service base URL, Azure SSL pins
///   - [NetworkClientName.firebase] → Firebase Realtime Database, Firebase SSL pins
///
/// The default (unnamed) [NetworkClient] resolves to the Azure client for
/// backwards compatibility with existing feature modules.
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

    final tokenStorage = getIt<TokenStorage>();

    // 2. Build shared interceptors (auth + token refresh + cache)
    //    SSL pinning is NOT shared — each host gets its own pinning interceptor.
    List<Interceptor> buildCommonInterceptors() => [
          if (!kIsWeb) RequestBypassInterceptor(),
          AuthInterceptor(tokenStorage),
          TokenRefreshInterceptor(
            tokenStorage: tokenStorage,
            refreshDio: Dio(),
            refreshEndpoint: '/auth/refresh',
          ),
          buildCacheInterceptor(),
        ];

    // 3. Azure Dio — base URL points to .NET API, pinned to Azure certs
    final azureDio = Dio(BaseOptions(
      baseUrl: Urls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    // SPKI pinning — works on all platforms including macOS/desktop
    // applySpkiPinning(azureDio, azureSpkiHashes);
    azureDio.interceptors.addAll([
      // Certificate pinning — Android/iOS only (null on web/desktop)
      if (buildCertPinningInterceptor(azureCertFingerprints) != null)
        buildCertPinningInterceptor(azureCertFingerprints)!,
      ...buildCommonInterceptors(),
    ]);

    // 4. Firebase Dio — no fixed baseUrl (full URLs passed per request),
    //    pinned to Firebase/Google certs
    final firebaseDio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    // SPKI pinning — works on all platforms including macOS/desktop
    // applySpkiPinning(firebaseDio, firebaseSpkiHashes);
    firebaseDio.interceptors.addAll([
      // Certificate pinning — Android/iOS only (null on web/desktop)
      // if (buildCertPinningInterceptor(firebaseCertFingerprints) != null)
      //   buildCertPinningInterceptor(firebaseCertFingerprints)!,
      ...buildCommonInterceptors(),
    ]);

    // 5. Register named NetworkClient instances
    getIt.registerLazySingleton<NetworkClient>(
      () => NetworkClientImpl(
        dio: azureDio,
        urlStrategy: PassthroughUrlStrategy(),
      ),
      instanceName: NetworkClientName.azure,
    );

    getIt.registerLazySingleton<NetworkClient>(
      () => NetworkClientImpl(
        dio: firebaseDio,
        urlStrategy: FirebaseUrlStrategy(),
      ),
      instanceName: NetworkClientName.firebase,
    );

    // 6. Default (unnamed) registration resolves to Azure client for
    //    backwards compatibility with existing feature modules.
    getIt.registerLazySingleton<NetworkClient>(
      () => getIt<NetworkClient>(instanceName: NetworkClientName.azure),
    );
  }

  /// Unregisters network dependencies for test teardown.
  static Future<void> reset() async {
    final getIt = GetIt.instance;
    for (final name in [
      NetworkClientName.azure,
      NetworkClientName.firebase,
      null,
    ]) {
      if (getIt.isRegistered<NetworkClient>(instanceName: name)) {
        await getIt.unregister<NetworkClient>(instanceName: name);
      }
    }
    if (getIt.isRegistered<TokenStorage>()) {
      await getIt.unregister<TokenStorage>();
    }
  }
}
