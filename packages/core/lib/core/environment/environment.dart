import 'package:flutter/services.dart';

import 'app_configuration.dart';
import 'environment_type.dart';

/// Resolves the active flavor.
/// [appFlavor] is set via `--flavor` on native platforms.
/// Falls back to `--dart-define=FLAVOR=...` for Web/Linux/Windows.
String _resolveFlavor() {
  if (appFlavor != null && appFlavor!.isNotEmpty) return appFlavor!;
  return const String.fromEnvironment('FLAVOR', defaultValue: 'dash');
}

/// Callback type for resolving flavor configurations.
/// The main app registers this to provide flavor-specific configs
/// that may depend on feature packages.
typedef FlavorConfigResolver = AppConfiguration Function(EnvironmentType type);

class Environment {
  static final Environment _singleton = Environment._internal();

  AppConfiguration? _configuration;
  FlavorConfigResolver? _resolver;

  factory Environment() => _singleton;

  Environment._internal();

  /// Register a flavor configuration resolver.
  /// Call this before [configure].
  void registerResolver(FlavorConfigResolver resolver) {
    _resolver = resolver;
  }

  void configure() {
    assert(_resolver != null,
        'Register a FlavorConfigResolver via registerResolver() before calling configure()');
    _configuration = _resolver!(EnvironmentType.fromFlavor(_resolveFlavor()));
  }

  AppConfiguration get configuration {
    assert(_configuration != null, 'configure the Environment');
    return _configuration!;
  }
}
