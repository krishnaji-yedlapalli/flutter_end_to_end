import 'package:flutter/material.dart';
import 'package:sample_latest/core/mixins/helper_methods.dart';

import 'package:sample_latest/features/daily_tracker_stub/daily_tracker_entry_point.dart' as daily_tracker;
import 'app_configuration.dart';

enum EnvironmentType { dash, flutter, dart, dailyTracker }

const defaultEnvironment = EnvironmentType.dailyTracker;

class Environment {
  static final Environment _singleton = Environment._internal();

  AppConfiguration? _configuration;

  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  void configure() {
    ///Fetching selected flavor Flavor
    EnvironmentType environmentType =
        const String.fromEnvironment('FLUTTER_APP_FLAVOR').isNotEmpty
            ? (HelperMethods.enumFromString(EnvironmentType.values,
                    const String.fromEnvironment('FLUTTER_APP_FLAVOR')) ??
            defaultEnvironment)
            : defaultEnvironment;

    _configuration = switch (environmentType) {
      EnvironmentType.dash => defaultConfiguration,
      EnvironmentType.flutter => flutterConfiguration,
      EnvironmentType.dart => dartConfiguration,
      EnvironmentType.dailyTracker => dailyConfiguration,
    };
  }

  AppConfiguration get configuration {
    assert(_configuration != null, 'configure the Environment');
    return _configuration!;
  }

  AppConfiguration get defaultConfiguration {
    return AppConfiguration(
      appBarLogoPath: 'asset/default_dash_flavor/leading_logo.png',
    );
  }

  AppConfiguration get dartConfiguration {
    return AppConfiguration(
        appBarLogoPath: 'asset/dart_flavor/dart_leading_logo.png',
        seedColor: Colors.indigoAccent,
        hoverColor: Colors.indigo.shade200);
  }

  AppConfiguration get flutterConfiguration {
    return AppConfiguration(
        appBarLogoPath: 'asset/flutter_flavor/flutter_leading_logo.png',
        seedColor: Colors.blue,
        hoverColor: Colors.blue.shade200);
  }

  AppConfiguration get dailyConfiguration {
    return AppConfiguration(
        appBarLogoPath: 'asset/flutter_flavor/flutter_leading_logo.png',
        seedColor: Colors.blue,
        hoverColor: Colors.blue.shade200,
        initialRoute: daily_tracker.DailyTrackerRouterModule.logInPath
    );
  }
}
