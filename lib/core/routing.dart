import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/models/school/school_model.dart';
import 'package:sample_latest/features/deep_linking/deep_linking.dart';
import 'package:sample_latest/ui/exception/page_not_found.dart';
import 'package:sample_latest/features/generative_ai/gemini.dart';
import 'package:sample_latest/features/plugins/plugins_dashboard.dart';
import 'package:sample_latest/features/push_notifcations/firebase_push_notifications.dart';
import 'package:sample_latest/features/push_notifcations/local_pushNotifications.dart';
import 'package:sample_latest/features/push_notifcations/notifications.dart';
import 'package:sample_latest/features/daily_tracker/daily_tracker_home.dart';
import 'package:sample_latest/features/regular_widgets/animations/custom_implicit_animation_widgets.dart';
import 'package:sample_latest/features/regular_widgets/animations/explicit_animation_widgets.dart';
import 'package:sample_latest/features/regular_widgets/animations/implicit_animations_widgets.dart';
import 'package:sample_latest/features/plugins/youtube.dart';
import 'package:sample_latest/features/regular_widgets/cupertino_components.dart';
import 'package:sample_latest/features/regular_widgets/material_components.dart';
import 'package:sample_latest/features/regular_widgets/dialogs.dart';
import 'package:sample_latest/features/regular_widgets/regular_widgets_dashboard.dart';
import 'package:sample_latest/global_variables.dart';
import 'package:sample_latest/features/automatic_keep_alive.dart';
import 'package:sample_latest/features/regular_widgets/selectable_text.dart';
import 'package:sample_latest/features/regular_widgets/tables.dart';
import 'package:sample_latest/features/routing_features/route_dashboard.dart';
import 'package:sample_latest/features/routing_features/shell_route/shell_child_one/shell_parent.dart';
import 'package:sample_latest/features/routing_features/shell_route/shell_child_one/shell_child_one.dart';
import 'package:sample_latest/features/routing_features/shell_route/shell_child_one/shell_child_three.dart';
import 'package:sample_latest/features/routing_features/shell_route/shell_child_one/shell_child_two.dart';
import 'package:sample_latest/features/routing_features/shell_route/shell_routing.dart';
import 'package:sample_latest/features/routing_features/state_ful_shell_routing_with_indexed.dart';
import 'package:sample_latest/features/routing_features/stateful_shell_routing_without_indexed.dart';
import 'package:sample_latest/features/scrolling/scroll_types.dart';
import 'package:sample_latest/features/regular_widgets/cards_list_view_grid.dart';
import 'package:sample_latest/features/schools/school_details.dart';
import 'package:sample_latest/features/schools/schools.dart';
import 'package:sample_latest/features/schools/student.dart';
import 'package:sample_latest/ui/home_screen.dart';
import 'package:sample_latest/features/isolates/isolate_home.dart';
import 'package:sample_latest/features/isolates/isolate_with_compute.dart';
import 'package:sample_latest/features/localization.dart';
import 'package:sample_latest/features/shortcuts/shortcuts_main.dart';
import 'package:sample_latest/features/upi_payments/easy_upi_payments.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/features/regular_widgets/stepper_ui.dart';
import 'package:sample_latest/utils/enums_type_def.dart';

import 'mixins/dialogs.dart';
import '../features/plugins/local_authentication.dart';

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
  static const String htmlRendering = 'htmlRendering';

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
  );

  /// Home items
  static RouteBase homeRoute() {
    return GoRoute(
        path: home,
        name: 'homescreen',
        builder: (BuildContext context, GoRouterState state) {
          return const FeatureDiscovery.withProvider(
              persistenceProvider: NoPersistenceProvider(),
          child: HomeScreen());
        },
        routes: [
          dashboardRoute(),
          schoolRoute(),
          goRoute(),
          GoRoute(
              path: 'keepalive',
              name: 'KeepAlive screen',
              builder: (context, state) {
                return const AutomaticKeepAliveScreen();
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
          pushNotification(),
          GoRoute(
            path: 'deep-linking',
            name: 'deeplinking',
            builder: (BuildContext context, GoRouterState state) {
              return DeepLinkingTesting();
            },
          ),
          GoRoute(
              path: 'gemini',
              builder: (context, state) {
                return const GeminiChatScreen();
              }),
          GoRoute(
              path: 'daily-tracker',
              builder: (context, state) {
                return const DailyTrackerHome();
              }),
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
          return const Tables();
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
          return  const FeatureDiscovery.withProvider(
              persistenceProvider: NoPersistenceProvider(),
          child:  Schools());
        },
        onExit: (context) async{
          bool res = await CustomDialogs.buildAlertDialogWithYesOrNo(context, title : '!!! Alert !!!', content: 'Are you sure U want to exit?');
          return res;
        },
        routes: [
          GoRoute(
              path: 'school-details',
              name: 'schoolDetails',
              redirect: (BuildContext context, GoRouterState state) => redirectWithToast(context, state : state, redirectPath: '/home/schools', paramKeys: ['schoolId'], toastMessage: 'Invalid School details'),
              builder: (BuildContext context, GoRouterState state) {
                return SchoolDetails(state.uri.queryParameters['schoolId'] ?? '', state.extra != null && state.extra is SchoolModel ? state.extra as SchoolModel : null);
              },
              routes: [
                GoRoute(
                    path: 'student',
                    name: 'student',
                    redirect: (BuildContext context, GoRouterState state) => redirectWithToast(context, state : state, redirectPath: '/home/schools', paramKeys: ['schoolId', 'studentId'], toastMessage: 'Invalid Student Details'),
                    builder: (context, state) {
                      return Student(studentId : state.uri.queryParameters['studentId'] ?? '', schoolId : state.uri.queryParameters['schoolId'] ?? '');
                    })
              ]),
        ]);
  }

  static GoRoute goRoute() {
    return GoRoute(path: 'route',
    parentNavigatorKey: navigatorKey,
    builder: (BuildContext context, GoRouterState state){
      return RoutingDashboard();
    },
    routes: [
      ShellRoute(
          navigatorKey: shellNavigatorKey,
          builder: (context, state, child) => ShellRouting(child),
          routes: [
            GoRoute(
              path: 'parent',
              parentNavigatorKey: shellNavigatorKey,
              builder: (context, state) =>  const ShellChildOne(),
              routes: [
                GoRoute(
                  path: 'child1',
                  parentNavigatorKey: shellNavigatorKey,
                  builder: (context, state) =>  const ShellChildOneChildOne(),
                  routes: [
                    GoRoute(
                        path: 'child2',
                        parentNavigatorKey: shellNavigatorKey,
                        builder: (context, state) =>  const ShellChildOneChildTwo(),
                      routes: [
                        GoRoute(
                            path: 'child3',
                            parentNavigatorKey: shellNavigatorKey,
                            builder: (context, state) =>  const ShellChildOneChildThree())
                      ]
                    )
                  ]
                )
              ]
            ),
         ]),
      StatefulShellRoute.indexedStack(builder: (context, state, navigationShell) => StateFulShellRoutingWithIndexed(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(path: '${RouteType.stateFullShellRoutingWithIndexed.name}/hi', builder: (context, state) => const Text('Hi'),),]),
            StatefulShellBranch(routes: [GoRoute(path: '${RouteType.stateFullShellRoutingWithIndexed.name}/hello', builder: (context, state) => const Text('Heloo'))]),
            StatefulShellBranch(routes: [GoRoute(path: '${RouteType.stateFullShellRoutingWithIndexed.name}/hola', builder: (context, state) => const Text('Hola'))]),
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
    String path = '/home/schools';
    if(message?.data['path'] != null) path = message?.data['path'];
   if(navigatorKey.currentContext != null) GoRouter.of(navigatorKey.currentContext!).push(path);
 }

  static void onLocalPushNotificationOpened(String? path) {
     path ??= '/home/schools';
    if(navigatorKey.currentContext != null) GoRouter.of(navigatorKey.currentContext!).push(path);
  }

  static String? redirectWithToast(BuildContext context,{required GoRouterState state, required String redirectPath, required List<String> paramKeys, required toastMessage}) {
    if(paramKeys.any((key) => !state.uri.queryParameters.containsKey(key))){
      return redirectPath;
    }
    return null;
  }

  static bool navigateToHome(BuildContext context) {

   var route = GoRouter.of(context);
    while (route.canPop()) {
      if(route.routerDelegate.currentConfiguration.uri.path == '/home/schools'){
        route.pop();
        break;
      }
      route.pop();
    }
    return true;
  }
}
