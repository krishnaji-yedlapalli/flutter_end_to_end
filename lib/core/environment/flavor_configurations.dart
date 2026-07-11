import 'package:flutter/material.dart';
import 'package:sample_latest/features/daily_tracker_stub/daily_tracker_entry_point.dart'
    as daily_tracker;
import 'app_configuration.dart';

final dashConfiguration = AppConfiguration(
  appBarLogoPath: 'asset/default_dash_flavor/leading_logo.png',
);

final dartConfiguration = AppConfiguration(
  appBarLogoPath: 'asset/dart_flavor/dart_leading_logo.png',
  seedColor: Colors.indigoAccent,
  hoverColor: Colors.indigo.shade200,
);

final flutterConfiguration = AppConfiguration(
  appBarLogoPath: 'asset/flutter_flavor/flutter_leading_logo.png',
  seedColor: Colors.blue,
  hoverColor: Colors.blue.shade200,
);

final dailyConfiguration = AppConfiguration(
  appBarLogoPath: 'asset/flutter_flavor/flutter_leading_logo.png',
  seedColor: Colors.blue,
  hoverColor: Colors.blue.shade200,
  initialRoute: daily_tracker.DailyTrackerRouterModule.logInPath,
);
