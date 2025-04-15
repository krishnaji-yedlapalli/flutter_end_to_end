import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/features/daily_tracker/core/daily_tracker_wrapper_page.dart';
import 'package:sample_latest/features/daily_tracker/features/authentication/login_page.dart';
import 'package:sample_latest/features/daily_tracker/features/users/presentation/profiles_page.dart';

import '../../../core/mixins/dialogs.dart';
import '../features/dashboard/presentation/page/daily_tracker_home.dart';

class DailyTrackerRouterModule {
  static final _dailyTrackerShellNavigatorKey = GlobalKey<NavigatorState>();

  static get dailyTrackerShellNavigatorKey => _dailyTrackerShellNavigatorKey;

  static ShellRoute dailyTrackerRoute() {
    return ShellRoute(
      navigatorKey: _dailyTrackerShellNavigatorKey,
      builder: (context, state, child) {
        return DailyTrackerWrapperPage(child: child);
      },
      routes: [
        GoRoute(path: 'login-page',
          name: 'login page',
          parentNavigatorKey: _dailyTrackerShellNavigatorKey,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(child: LoginForm());
          }
        ),
        GoRoute(path: 'users-page',
            name: 'users page',
            parentNavigatorKey: _dailyTrackerShellNavigatorKey,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: UsersView());
            }
        ),
        GoRoute(
          path: 'daily-tracker',
          name: 'daily tracker',
          parentNavigatorKey: _dailyTrackerShellNavigatorKey,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(child: DailyTrackerHome());
          },
          // onExit: (context) async {
            // bool res = await CustomDialogs.buildAlertDialogWithYesOrNo(
            //   context,
            //   title: '!!! Alert !!!',
            //   content: 'Are you sure you want to exit?',
            // );
            // return res;
          // },
          routes: [
          ],
        ),
      ],
    );
  }
}
