import 'package:get_it/get_it.dart';
import 'package:sample_latest/core/firebase/services/firebase_analytics_service.dart';
import 'package:sample_latest/core/firebase/services/firebase_auth_service.dart';
import 'package:sample_latest/core/firebase/services/firebase_crashlytics_service.dart';
import 'package:sample_latest/core/firebase/services/firebase_messaging_service.dart';
import 'package:sample_latest/core/firebase/services/firebase_remote_config_service.dart';
import 'package:sample_latest/core/firebase/services_impl/firebase_analytics_service_impl.dart';
import 'package:sample_latest/core/firebase/services_impl/firebase_auth_service_impl.dart';
import 'package:sample_latest/core/firebase/services_impl/firebase_crashlytics_service_impl.dart';
import 'package:sample_latest/core/firebase/services_impl/firebase_messaging_service_impl.dart';
import 'package:sample_latest/core/firebase/services_impl/firebase_remote_config_service_impl.dart';

/// Registers all Firebase services in GetIt — always real implementations.
///
/// All services are registered unconditionally.
/// To enable/disable data collection at runtime, use:
/// - [FirebaseCrashlyticsService.setCrashlyticsCollectionEnabled]
/// - [FirebaseAnalyticsService.setAnalyticsCollectionEnabled]
class FirebaseInjectionModule {
  const FirebaseInjectionModule._();

  static final GetIt _getIt = GetIt.instance;

  /// Registers all Firebase services as lazy singletons.
  static void register() {
    _getIt.registerLazySingleton<FirebaseAnalyticsService>(
      () => FirebaseAnalyticsServiceImpl(),
    );

    _getIt.registerLazySingleton<FirebaseCrashlyticsService>(
      () => FirebaseCrashlyticsServiceImpl(),
    );

    _getIt.registerLazySingleton<FirebaseRemoteConfigService>(
      () => FirebaseRemoteConfigServiceImpl(),
    );

    _getIt.registerLazySingleton<FirebaseMessagingService>(
      () => FirebaseMessagingServiceImpl(),
    );

    _getIt.registerLazySingleton<FirebaseAuthService>(
      () => FirebaseAuthServiceImpl(),
    );
  }
}
