import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:sample_latest/models/school/school_details_model.dart';
import 'package:sample_latest/models/school/school_model.dart';
import 'package:sample_latest/models/school/student_model.dart';
import 'package:sample_latest/ui/exception/page_not_found.dart';
import 'package:sample_latest/ui/plugins/plugins_dashboard.dart';
import 'package:sample_latest/ui/push_notifcations/firebase_push_notifications.dart';
import 'package:sample_latest/ui/push_notifcations/local_pushNotifications.dart';
import 'package:sample_latest/ui/push_notifcations/notifications.dart';
import 'package:sample_latest/ui/regular_widgets/animations/custom_implicit_animation_widgets.dart';
import 'package:sample_latest/ui/regular_widgets/animations/explicit_animation_widgets.dart';
import 'package:sample_latest/ui/regular_widgets/animations/implicit_animations_widgets.dart';
import 'package:sample_latest/ui/plugins/youtube.dart';
import 'package:sample_latest/ui/regular_widgets/cupertino_components.dart';
import 'package:sample_latest/ui/regular_widgets/material_components.dart';
import 'package:sample_latest/ui/regular_widgets/dialogs.dart';
import 'package:sample_latest/ui/regular_widgets/regular_widgets_dashboard.dart';
import 'package:sample_latest/global_variables.dart';
import 'package:sample_latest/main.dart';
import 'package:sample_latest/ui/automatic_keep_alive.dart';
import 'package:sample_latest/ui/regular_widgets/selectable_text.dart';
import 'package:sample_latest/ui/regular_widgets/tables.dart';
import 'package:sample_latest/ui/routing_features/route_dashboard.dart';
import 'package:sample_latest/ui/routing_features/shell_route/shell_child_one.dart';
import 'package:sample_latest/ui/routing_features/shell_route/shell_child_three.dart';
import 'package:sample_latest/ui/routing_features/shell_route/shell_child_two.dart';
import 'package:sample_latest/ui/routing_features/shell_route/shell_routing.dart';
import 'package:sample_latest/ui/routing_features/state_ful_shell_routing_with_indexed.dart';
import 'package:sample_latest/ui/routing_features/stateful_shell_routing_without_indexed.dart';
import 'package:sample_latest/ui/scrolling/scroll_types.dart';
import 'package:sample_latest/ui/shortcuts/call_back_shortcuts.dart';
import 'package:sample_latest/ui/regular_widgets/cards_list_view_grid.dart';
import 'package:sample_latest/ui/schools/school_details.dart';
import 'package:sample_latest/ui/schools/schools.dart';
import 'package:sample_latest/ui/schools/student.dart';
import 'package:sample_latest/ui/home_screen.dart';
import 'package:sample_latest/ui/isolates/isolate_home.dart';
import 'package:sample_latest/ui/isolates/isolate_with_compute.dart';
import 'package:sample_latest/ui/localization.dart';
import 'package:sample_latest/ui/shortcuts/shortcuts_main.dart';
import 'package:sample_latest/ui/upi_payments/easy_upi_payments.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/ui/regular_widgets/stepper_ui.dart';
import 'package:sample_latest/utils/enums_type_def.dart';

import 'ui/plugins/local_authentication.dart';

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

  static final shellNavigatorKey = GlobalKey<NavigatorState>();


  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: home,
    routes: <RouteBase>[
      homeRoute(),
    ],
    errorBuilder: (context, state) => PageNotFound(state),
    redirect: (context, state) async {

      return null;
    },
    // onException: (context, state, goRouter) {
    //   debugPrint('On ROute exception');
    // }
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
          schoolRoute(),
          goRoute(),
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
          ),
          pushNotification()
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

  static GoRoute schoolRoute() {
    return GoRoute(
        path: 'schools',
        name: 'schools',
        builder: (BuildContext context, GoRouterState state) {
          return const Schools();
        },
        routes: [
          GoRoute(
              path: 'schoolDetails',
              name: 'schoolDetails',
              builder: (BuildContext context, GoRouterState state) {
                Map<String, dynamic> query = {};
                query.addAll(state.uri.queryParameters);
                return SchoolDetails(SchoolModel.fromRouteJson(query));
              },
              routes: [
                GoRoute(
                    path: 'student/:schoolId/:studentId',
                    name: 'student',
                    builder: (context, state) {
                      return Student(studentId : state.pathParameters['studentId'] ?? '', schoolId : state.pathParameters['schoolId'] ?? '', schoolName: state.uri.queryParameters['schoolName'] ?? '');
                    })
              ]),
        ]);
  }

  static GoRoute goRoute() {
    return GoRoute(path: 'route',
    builder: (BuildContext context, GoRouterState state){
      return RoutingDashboard();
    },
    routes: [
      ShellRoute(
          navigatorKey: shellNavigatorKey,
          builder: (context, state, child) => ShellRouting(child),
          routes: [
            GoRoute(
              path: 'shellroute/child1',
              parentNavigatorKey: shellNavigatorKey,
              builder: (context, state) =>  ShellChildOne(),
            ),
            GoRoute(
              path: 'child2',
              parentNavigatorKey: shellNavigatorKey,
              builder: (context, state) =>  ShellChildTwo(),
            ),
            GoRoute(
              path: 'child3',
              parentNavigatorKey: shellNavigatorKey,
              builder: (context, state) =>  ShellChildThree(),
            ),
         ]),
      StatefulShellRoute.indexedStack(builder: (context, state, navigationShell) => StateFulShellRoutingWithIndexed(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(path: '${RouteType.stateFullShellRoutingWithIndexed.name}/hi', builder: (context, state) => Text('Hi'),),]),
            StatefulShellBranch(routes: [GoRoute(path: '${RouteType.stateFullShellRoutingWithIndexed.name}/hello', builder: (context, state) => Text('Heloo'))]),
            StatefulShellBranch(routes: [GoRoute(path: '${RouteType.stateFullShellRoutingWithIndexed.name}/hola', builder: (context, state) => Text('Hola'))]),
          ]
      ),
      GoRoute(path: RouteType.stateFullShellRoutingWithoutIndexed.name,
          builder: (BuildContext context, GoRouterState state) => const StateFulShellRoutingWithoutIndexed()
      )
      ]);
}

static ShellRoute pushNotification() {
    return  ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => NotificationWithRemoteAndLocal(child),
        routes: [
          GoRoute(
            path: 'push-notifications/remote-notifications',
            parentNavigatorKey: shellNavigatorKey,
            builder: (context, state) =>  const FirebasePushNotifications(),
          ),
          GoRoute(
            path: 'push-notifications/local-notifications',
            parentNavigatorKey: shellNavigatorKey,
            builder: (context, state) =>  const LocalPushNotifications(),
          ),
        ]);
}

 static void onPushNotificationOpened(RemoteMessage? message) {
   if(navigatorKey.currentContext != null) GoRouter.of(navigatorKey.currentContext!).push('/home/schools');
 }
}
