import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/screens/dashboard/dashboard.dart';
import 'package:sample_latest/global_variables.dart';
import 'package:sample_latest/main.dart';
import 'package:sample_latest/screens/automatic_keep_alive.dart';
import 'package:sample_latest/screens/dashboard/call_back_shortcuts.dart';
import 'package:sample_latest/screens/dashboard/cards_list_view_grid.dart';
import 'package:sample_latest/screens/child_routing_school/school_details.dart';
import 'package:sample_latest/screens/child_routing_school/schools.dart';
import 'package:sample_latest/screens/child_routing_school/students.dart';
import 'package:sample_latest/screens/home_screen.dart';
import 'package:sample_latest/screens/localization.dart';
import 'package:sample_latest/screens/upi_payments/easy_upi_payments.dart';

GoRouter buildRoute(BuildContext context) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/home',
    routes: <RouteBase>[
      GoRoute(
          path: '/home',
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
          ]),
      GoRoute(
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
          ]),

      StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return DashboardScreen(navigationShell);
          },
          branches: [
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
            ])
          ])
      // GoRoute(
      //   path : '/dashboard',
      //     builder: ,
      //     routes: [
      //       StatefulShellRoute.indexedStack(
      //           // navigatorKey: shellRouteKey,
      //           parentNavigatorKey: navigatorKey,
      //           builder: (context, state, child){
      //             return DashboardScreen(child);
      //           },
      //           branches: [
      //             GoRoute(
      //               path: '/cardLayouts',
      //               name: 'Card Layouts',
      //               parentNavigatorKey: shellRouteKey,
      //               builder: (BuildContext context, GoRouterState state) {
      //                 return const CardsLayout();
      //               },
      //             ),
      //             GoRoute(
      //               path: '/actionShortcuts',
      //               name: 'Actio shortcuts',
      //               parentNavigatorKey: shellRouteKey,
      //               builder: (BuildContext context, GoRouterState state) {
      //                 return const CardsLayout();
      //               },
      //             ),
      //           ])
      //     ])
    ],
  );
}
