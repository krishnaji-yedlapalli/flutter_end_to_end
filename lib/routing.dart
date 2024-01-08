import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/screens/plugins/plugins_dashboard.dart';
import 'package:sample_latest/screens/regular_widgets/animations/custom_implicit_animation_widgets.dart';
import 'package:sample_latest/screens/regular_widgets/animations/explicit_animation_widgets.dart';
import 'package:sample_latest/screens/regular_widgets/animations/implicit_animations_widgets.dart';
import 'package:sample_latest/screens/plugins/youtube.dart';
import 'package:sample_latest/screens/regular_widgets/cupertino_components.dart';
import 'package:sample_latest/screens/regular_widgets/material_components.dart';
import 'package:sample_latest/screens/regular_widgets/dialogs.dart';
import 'package:sample_latest/screens/regular_widgets/regular_widgets_dashboard.dart';
import 'package:sample_latest/global_variables.dart';
import 'package:sample_latest/main.dart';
import 'package:sample_latest/screens/automatic_keep_alive.dart';
import 'package:sample_latest/screens/regular_widgets/selectable_text.dart';
import 'package:sample_latest/screens/regular_widgets/tables.dart';
import 'package:sample_latest/screens/scrolling/scroll_types.dart';
import 'package:sample_latest/screens/shortcuts/call_back_shortcuts.dart';
import 'package:sample_latest/screens/regular_widgets/cards_list_view_grid.dart';
import 'package:sample_latest/screens/child_routing_school/school_details.dart';
import 'package:sample_latest/screens/child_routing_school/schools.dart';
import 'package:sample_latest/screens/child_routing_school/students.dart';
import 'package:sample_latest/screens/home_screen.dart';
import 'package:sample_latest/screens/isolates/isolate_home.dart';
import 'package:sample_latest/screens/isolates/isolate_with_compute.dart';
import 'package:sample_latest/screens/localization.dart';
import 'package:sample_latest/screens/shortcuts/shortcuts_main.dart';
import 'package:sample_latest/screens/upi_payments/easy_upi_payments.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/widgets/stepper_ui.dart';

import 'screens/plugins/local_authentication.dart';

class Routing {
  static const String home = '/home';
  static const String dashboard = 'dashboard';

  /// Dashboard routes
  static const String materialComponents = 'materialComponents';
  static const String cupertinoComponents = 'cupertinoComponents';
  static const String dialogs = 'dialogs';
  static const String implicitAnimations = 'implicitAnimations';
  static const String customImplicitAnimations = 'customImplicitAnimations';
  static const String explicitAnimations = 'explicitAnimations';
  static const String selectableText = 'selectableText';
  static const String tables = 'tables';
  static const String cardLayouts = 'cardLayouts';
  static const String stepper = 'stepper';

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: home,
    // errorBuilder: _errorBuilder,
    routes: <RouteBase>[homeRoute(), schollRoute()],
  );

  /// Home items
  static RouteBase homeRoute() {
    return GoRoute(
        path: home,
        name: 'homescreen',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
        routes: [
          dashboardRoute(),
          GoRoute(
              path: 'keepalive',
              name: 'KeepAlive screen',
              builder: (context, state) {
                return AutomaticKeepAliveScreen();
              }),
          GoRoute(
              path: 'localization',
              name: 'Localization',
              builder: (context, state) {
                return const LocalizationDatePicker();
              }),
          GoRoute(
              path: 'upipayments',
              name: 'Upi Payments',
              builder: (context, state) {
                return const EasyUpiPayments();
              }),
          GoRoute(
              path: 'isolates',
              name: 'Isolates',
              builder: (context, state) {
                return const IsolateHome();
              },
              routes: [
                GoRoute(
                    path: 'isolateWithWithOutLag',
                    name: 'Isolates With without Lag',
                    builder: (context, state) {
                      return IsolateWithCompute();
                    }),
                GoRoute(
                    path: 'isolateWithSpawn',
                    name: 'Isolateds With Spwan',
                    builder: (context, state) {
                      return const EasyUpiPayments();
                    }),
              ]),
          GoRoute(
            path: 'actionShortcuts',
            name: 'Action shortcuts',
            builder: (BuildContext context, GoRouterState state) {
              return const ShortcutsTabView();
            },
          ),
          GoRoute(
              path: 'plugins',
              name: 'Plugins',
              builder: (BuildContext context, GoRouterState state) {
                return PluginsDashboard();
              },
              routes: [
                GoRoute(
                  path: 'youtube',
                  name: 'Youtube',
                  builder: (BuildContext context, GoRouterState state) {
                    return Youtube();
                  },
                ),
                GoRoute(
                  path: 'localAuthentication',
                  name: 'Local Authentication',
                  builder: (BuildContext context, GoRouterState state) {
                    return const LocalAuthentication();
                  },
                ),
              ]),
          GoRoute(
            path: 'scrollTypes',
            name: 'Scroll Types',
            builder: (BuildContext context, GoRouterState state) {
              return const ScrollTypes();
            },
          )
        ]);
  }

  /// Dashboard Routes
  static RouteBase dashboardRoute() {
    List<({String path, String name, Widget Function(BuildContext context, GoRouterState state) builder})> dashboardChildRouteList = [
      (
        path: materialComponents,
        name: 'Material Components',
        builder: (BuildContext context, GoRouterState state) {
          return const MaterialComponents();
        },
      ),
      (
        path: cupertinoComponents,
        name: 'Cupertino Components',
        builder: (BuildContext context, GoRouterState state) {
          return const CupertinoComponents();
        },
      ),
      (
        path: dialogs,
        name: 'Dialogs',
        builder: (BuildContext context, GoRouterState state) {
          return const Dialogs();
        },
      ),
      (
        path: implicitAnimations,
        name: 'Implicit Animations',
        builder: (BuildContext context, GoRouterState state) {
          return const ImplicitAnimationsWidgets();
        },
      ),
      (
        path: customImplicitAnimations,
        name: 'Custom Implicit Animations',
        builder: (BuildContext context, GoRouterState state) {
          return const CustomImplicitAnimationsWidgets();
        },
      ),
      (
        path: explicitAnimations,
        name: 'Explicit Animations',
        builder: (BuildContext context, GoRouterState state) {
          return const ExplicitAnimationsWidgets();
        },
      ),
      (
        path: tables,
        name: 'Tables',
        builder: (BuildContext context, GoRouterState state) {
          return Tables();
        },
      ),
      (
        path: selectableText,
        name: 'Selectable Text',
        builder: (BuildContext context, GoRouterState state) {
          return const SelectableTextSample();
        },
      ),
      (
        path: cardLayouts,
        name: 'Card Layouts',
        builder: (BuildContext context, GoRouterState state) {
          return const CardsLayout();
        },
      ),
      (
        path: stepper,
        name: 'Stepper',
        builder: (BuildContext context, GoRouterState state) {
          return const StepperExampleApp();
        },
      ),
    ];

    if (DeviceConfiguration.isMobileResolution) {
      return GoRoute(
          path: dashboard,
          name: 'Regularly used widgets',
          builder: (BuildContext context, GoRouterState state) {
            return RegularlyUsedWidgetsDashboard();
          },
          routes: dashboardChildRouteList.map((e) => GoRoute(path: e.path, name: e.name, builder: (context, state) => Scaffold(appBar: AppBar(title: Text(e.name)), body: e.builder(context, state)))).toList());
    } else {
      return StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return RegularlyUsedWidgetsDashboard(navigationShell: navigationShell);
          },
          branches: dashboardChildRouteList.map((e) => StatefulShellBranch(routes: [GoRoute(path: '$dashboard/${e.path}', name: e.name, builder: e.builder)])).toList());
    }
  }

  static GoRoute schollRoute() {
    return GoRoute(
        path: '/schools',
        name: 'schools',
        builder: (BuildContext context, GoRouterState state) {
          return const Schools();
        },
        routes: [
          GoRoute(
              path: 'schoolDetails',
              name: 'schoolDetails',
              builder: (BuildContext context, GoRouterState state) {
                return SchoolDetails((state.queryParameters['name'], state.queryParameters['address'], int.parse(state.queryParameters['pincode'] ?? '0')) as (String, String, int));
              },
              routes: [
                GoRoute(
                    path: 'students',
                    name: 'students',
                    builder: (context, state) {
                      return Students();
                    })
              ]),
        ]);
  }

  static Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return Container(child: Text('error'));
  }
}
