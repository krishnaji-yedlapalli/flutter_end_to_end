import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_latest/core/firebase/config/firebase_options_config.dart';
import 'package:sample_latest/core/firebase/firebase_injection_module.dart';
import 'package:sample_latest/core/firebase/services/firebase_analytics_service.dart';
import 'package:sample_latest/core/firebase/services/firebase_auth_service.dart';
import 'package:sample_latest/core/firebase/services/firebase_crashlytics_service.dart';
import 'package:sample_latest/core/firebase/services/firebase_messaging_service.dart';
import 'package:sample_latest/core/firebase/services/firebase_remote_config_service.dart';

/// Orchestrates Firebase initialization.
///
/// Called once from `main.dart`. Handles:
/// 1. `Firebase.initializeApp()` with platform-specific options.
/// 2. Registering services in GetIt via [FirebaseInjectionModule].
/// 3. Initializing each service.
class FirebaseInitializer {
  const FirebaseInitializer._();

  /// Initializes Firebase and all services.
  static Future<void> initialize() async {
    // Skip Firebase on unsupported platforms
    if (!kIsWeb && Platform.isLinux) return;

    // 1. Initialize Firebase Core.
    try {
      await Firebase.initializeApp(
        options: FirebaseOptionsConfig.currentPlatform,
      );
    } on FirebaseException catch (e) {
      if (e.code != 'duplicate-app') rethrow;
    }

    // 2. Register all services in GetIt
    FirebaseInjectionModule.register();

    // 3. Initialize all services
    await GetIt.I<FirebaseAnalyticsService>().initialize();
    await GetIt.I<FirebaseCrashlyticsService>().initialize();
    await GetIt.I<FirebaseRemoteConfigService>().initialize();
    await GetIt.I<FirebaseMessagingService>().initialize();
    await GetIt.I<FirebaseAuthService>().initialize();
  }
}
