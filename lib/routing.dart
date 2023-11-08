import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/screens/regular_widgets/dialogs.dart';
import 'package:sample_latest/screens/regular_widgets/regular_widgets_dashboard.dart';
import 'package:sample_latest/global_variables.dart';
import 'package:sample_latest/main.dart';
import 'package:sample_latest/screens/automatic_keep_alive.dart';
import 'package:sample_latest/screens/regular_widgets/call_back_shortcuts.dart';
import 'package:sample_latest/screens/regular_widgets/cards_list_view_grid.dart';
import 'package:sample_latest/screens/child_routing_school/school_details.dart';
import 'package:sample_latest/screens/child_routing_school/schools.dart';
import 'package:sample_latest/screens/child_routing_school/students.dart';
import 'package:sample_latest/screens/home_screen.dart';
import 'package:sample_latest/screens/isolates/isolate_home.dart';
import 'package:sample_latest/screens/isolates/isolate_with_compute.dart';
import 'package:sample_latest/screens/localization.dart';
import 'package:sample_latest/screens/upi_payments/easy_upi_payments.dart';
import 'package:sample_latest/widgets/stepper_ui.dart';


class Routing {

  static const home = '/home';

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: home,
    errorBuilder: _errorBuilder,
    routes: <RouteBase>[
      GoRoute(
          path: home,
          name: 'homescreen',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
          routes: [
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
                ]
            )
          ]),
      schollRoute(),
      dashboardRoute()
    ],
  );

  static StatefulShellRoute dashboardRoute() {
    return   StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return RegularlyUsedWidgetsDashboard(navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/dashboard/dialogs',
              name: 'Dialogs',
              builder: (BuildContext context, GoRouterState state) {
                return const Dialogs();
              },
            ),
          ]),
          StatefulShellBranch(navigatorKey: shellRouteCardsKey, routes: [
            GoRoute(
              path: '/dashboard/cardLayouts',
              name: 'Card Layouts',
              builder: (BuildContext context, GoRouterState state) {
                return const CardsLayout();
              },
            ),
          ]),
          StatefulShellBranch(navigatorKey: shellRouteShortcutsKey, routes: [
            GoRoute(
              path: '/dashboard/actionShortcuts',
              name: 'Actio shortcuts',
              builder: (BuildContext context, GoRouterState state) {
                return const CallBackShortCutsView();
              },
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/dashboard/stepper',
              name: 'Stepper',
              builder: (BuildContext context, GoRouterState state) {
                return const StepperExampleApp();
              },
            ),
          ]),
        ]);
  }

  static GoRoute schollRoute() {
    return  GoRoute(
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
                return SchoolDetails((state.queryParameters['name'], state.queryParameters['address'], int.parse(state.queryParameters['pincode'] ?? '0'))
                as(String, String, int)
                );
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
    return Container();
  }
}