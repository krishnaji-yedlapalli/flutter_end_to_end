import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/features/daily_tracker/core/daily_tracker_wrapper_page.dart';
import 'package:sample_latest/features/daily_tracker/core/services/session_manager.dart';
import 'package:sample_latest/features/daily_tracker/features/authentication/login_page.dart';
import 'package:sample_latest/features/daily_tracker/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:sample_latest/features/daily_tracker/features/users/presentation/profiles_page.dart';

import '../../../core/mixins/dialogs.dart';
import '../../../core/routing.dart';
import '../features/dashboard/presentation/page/daily_tracker_home.dart';

class DailyTrackerRouterModule {
  static final _dailyTrackerShellNavigatorKey = GlobalKey<NavigatorState>();

  static get dailyTrackerShellNavigatorKey => _dailyTrackerShellNavigatorKey;

  static const _parentPath = 'tracker';
  static const _loginPage = '$_parentPath/login-page';
  static const _profilesPage = '$_parentPath/profiles-page';
  static const _dailyTrackerDashboardPage = '$_parentPath/daily-tracker-dashboard';


  static const logInPath = '${Routing.home}/$_loginPage';
  static const profilesPath = '${Routing.home}/$_profilesPage';
  static const dailyTrackerDashboardPath = '${Routing.home}/$_dailyTrackerDashboardPage';

  static ShellRoute dailyTrackerRoute() {
    return ShellRoute(
      navigatorKey: _dailyTrackerShellNavigatorKey,
      builder: (context, state, child) {
        return DailyTrackerWrapperPage(child: child);
      },
      routes: [
        GoRoute(path: _loginPage,
          name: 'login page',
          parentNavigatorKey: _dailyTrackerShellNavigatorKey,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(child: LoginForm());
          },
          redirect: (context, state) async {
            const storage = FlutterSecureStorage();
            if(await storage.containsKey(key: 'loginDetails') && (state.path?.contains(_loginPage) ?? false)){
             return profilesPath;
          }
          return null;
          }
        ),
        GoRoute(path: _profilesPage,
            name: 'users page',
            parentNavigatorKey: _dailyTrackerShellNavigatorKey,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: UsersView());
            }
        ),
        GoRoute(
          path: _dailyTrackerDashboardPage,
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
