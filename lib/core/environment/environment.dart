import 'package:flutter/services.dart';

import 'app_configuration.dart';
import 'environment_type.dart';
import 'flavor_configurations.dart';

/// Resolves the active flavor.
/// [appFlavor] is set via `--flavor` on native platforms.
/// Falls back to `--dart-define=FLAVOR=...` for Web/Linux/Windows.
String _resolveFlavor() {
  if (appFlavor != null && appFlavor!.isNotEmpty) return appFlavor!;
  return const String.fromEnvironment('FLAVOR', defaultValue: 'dash');
}

class Environment {
  static final Environment _singleton = Environment._internal();

  AppConfiguration? _configuration;

  factory Environment() => _singleton;

  Environment._internal();

  void configure() {
    _configuration =
        _configurationFor(EnvironmentType.fromFlavor(_resolveFlavor()));
  }

  AppConfiguration get configuration {
    assert(_configuration != null, 'configure the Environment');
    return _configuration!;
  }

  AppConfiguration _configurationFor(EnvironmentType type) {
    return switch (type) {
      EnvironmentType.dash => dashConfiguration,
      EnvironmentType.flutter => flutterConfiguration,
      EnvironmentType.dart => dartConfiguration,
      EnvironmentType.dailyTracker => dailyConfiguration,
    };
  }
}
