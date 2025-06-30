import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/features/smart_control_mqtt_iot_/core/smart_control_mqtt_wrapper_page.dart';

import '../../../core/routing.dart';
import '../features/dashboard/presentation/smart_control_mqtt_dashboard.dart';
import '../features/on_and_off/presentation/on_and_off_view.dart';

class SmartControlMqttRouterModule {
  static final _smartControlTrackerShellNavigatorKey = GlobalKey<NavigatorState>();

  static get smartControlTrackerShellNavigatorKey => _smartControlTrackerShellNavigatorKey;

  static const _parentPath = 'smart-control-mqtt';
  static const _dashboard = '$_parentPath/dashboard';
  static const _onAndOff = 'on-off';

  static const dashboardPath = '${Routing.home}/$_dashboard';
  static const onAndOffPath = '${Routing.home}/$_dashboard/$_onAndOff';

  static ShellRoute smartControlTrackerRoute() {
    return ShellRoute(
      navigatorKey: _smartControlTrackerShellNavigatorKey,
      builder: (context, state, child) {
        return SmartControlMqttWrapperPage(child: child);
      },
      routes: [
        GoRoute(
            path: _dashboard,
            name: 'dashboard page mqtt',
            parentNavigatorKey: _smartControlTrackerShellNavigatorKey,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: SmartControlMqttDashboard());
            },
        routes: [
          GoRoute(path: _onAndOff,
            parentNavigatorKey: _smartControlTrackerShellNavigatorKey,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: OnAndOffView());
            },
          )
        ]
        ),
      ],
    );
  }
}
