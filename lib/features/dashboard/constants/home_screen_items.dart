import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/core/utils/enums_type_def.dart';
import 'package:flutter/material.dart';

import '../../daily_tracker_stub/daily_tracker_entry_point.dart'
    as daily_tracker;

typedef HomeScreenItem = (String, ScreenType, IconData, {String? des});

final List<HomeScreenItem> homeScreenItems = [
  (
    'Dashboard',
    ScreenType.dashboard,
    Icons.dashboard,
    des:
        'It contains Shell Routing along with Material and Cupertino components'
  ),
  (
    'School Journey with Clean Architecture',
    ScreenType.school,
    Icons.school,
    des:
        'This Journey helps the developer to learn to develop the application with Clean architecture by applying solid principles'
  ),
  (
    'Localization',
    ScreenType.localizationWithCalendar,
    Icons.language,
    des: 'Localization and Internalization was implemented in this'
  ),
  (
    'Push Notifications',
    ScreenType.pushNotifications,
    Icons.notifications,
    des: 'Firebase push notifications'
  ),
  (
    'Deep Linking',
    ScreenType.deepLinking,
    Icons.notifications,
    des: 'Test the deeplink in device'
  ),
  (
    'Adaptive & Responsive Widgets',
    ScreenType.adaptiveAndResponsiveWidgets,
    Icons.language,
    des: 'Localization and Internalization was implemented in this'
  ),
  (
    'scrollTypes',
    ScreenType.scrollTypes,
    Icons.poll,
    des: 'Here we can access different types of plugins'
  ),
  (
    'Routing concept',
    ScreenType.routing,
    Icons.school,
    des: 'This describes the routing'
  ),
  if (!daily_tracker.DailyTrackerRouterModule.isStub)
    (
      'Daily Tracker UI',
      ScreenType.dailyTracker,
      Icons.accessibility_sharp,
      des: 'We can track daily activities'
    ),
  (
    'Automatci Keep alive',
    ScreenType.automaticKeepAlive,
    Icons.tab,
    des: 'This makes the screen alive if we navigated to another tab as well'
  ),
  (
    'Isolates',
    ScreenType.isolates,
    Icons.memory,
    des: 'Currently works in Mobile application only'
  ),
  (
    'Call Back Shortcuts',
    ScreenType.shortcuts,
    Icons.app_shortcut,
    des: 'Using keyboard shortcuts we can manipulate the options in the screen'
  ),
  (
    'Smart control MQtt to control the devices using IOT',
    ScreenType.smartControlMqtt,
    Icons.electric_bolt,
    des:
        'This Journey helps the developer to learn to develop the application with Clean architecture by applying solid principles'
  ),
  (
    'Smart control to control the devices using IOT',
    ScreenType.smartControl,
    Icons.electric_bolt,
    des:
        'This Journey helps the developer to learn to develop the application with Clean architecture by applying solid principles'
  ),
];

String homeScreenRoutePath(ScreenType type) => switch (type) {
      ScreenType.dashboard => DeviceConfiguration.isMobileResolution
          ? '/home/dashboard'
          : '/home/dashboard/materialComponents',
      ScreenType.school => '/home/schools',
      ScreenType.automaticKeepAlive => '/home/keepalive',
      ScreenType.localizationWithCalendar => '/home/localization',
      ScreenType.isolates => '/home/isolates',
      ScreenType.shortcuts => '/home/actionShortcuts',
      ScreenType.scrollTypes => '/home/scrollTypes',
      ScreenType.routing => '/home/route',
      ScreenType.pushNotifications =>
        '/home/push-notifications/remote-notifications',
      ScreenType.deepLinking => '/home/deep-linking',
      ScreenType.dailyTracker =>
        daily_tracker.DailyTrackerRouterModule.logInPath,
      ScreenType.smartControl => '/home/smart-control/dashboard',
      ScreenType.smartControlMqtt => '/home/smart-control-mqtt/dashboard',
      ScreenType.adaptiveAndResponsiveWidgets => '/home/adaptive-responsive',
    };
