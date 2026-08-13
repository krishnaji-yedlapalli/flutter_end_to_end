import 'package:app_core/core/environment/app_configuration.dart';
import 'package:app_core/core/environment/environment_type.dart';
import 'package:app_core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

AppConfiguration resolveFlavorConfig(EnvironmentType type) {
  return AppConfiguration(
    appBarLogoPath: 'asset/default_dash_flavor/leading_logo.png',
  );
}

class TestConfigurationData {
  static const List<Size> screenSizes = [
    // Size(320, 480), // Small Mobile: e.g., old iPhone SE
    Size(375, 667), // Regular Mobile: e.g., iPhone 8
    Size(768, 1024), // Tablet: e.g., iPad
    Size(1440, 900), // Desktop: Typical resolution
  ];

  static const supportedLocales = [
    Locale('en'),
    Locale('es'),
    Locale('hi'),
    Locale('he'),
  ];

  static const localizationDelegate = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}
