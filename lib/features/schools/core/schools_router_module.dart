import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/features/schools/core/school_module_wrapper_page.dart';
import 'package:sample_latest/features/schools/shared/models/school_view_model.dart';

import '../../../core/mixins/dialogs.dart';
import '../../../core/router_helper.dart';
import '../data/model/school_model.dart';
import '../presentation/screens/school_details/school_details.dart';
import '../presentation/screens/schools/schools.dart';
import '../presentation/screens/student/student.dart';

class SchoolRouterModule {
  static final _schoolShellNavigatorKey = GlobalKey<NavigatorState>();

  static get schoolShellNavigatorKey => _schoolShellNavigatorKey;

  static ShellRoute schoolRoute() {
    return ShellRoute(
      navigatorKey: _schoolShellNavigatorKey,
      builder: (context, state, child) {
        return SchoolModuleWrapperPage(child: child);
      },
      routes: [
        GoRoute(
          path: 'schools',
          name: 'schools',
          parentNavigatorKey: _schoolShellNavigatorKey,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(child: Schools());
          },
          onExit: (context) async {
            bool res = await CustomDialogs.buildAlertDialogWithYesOrNo(
              context,
              title: '!!! Alert !!!',
              content: 'Are you sure you want to exit?',
            );
            return res;
          },
          routes: [
            GoRoute(
              path: 'school-details',
              name: 'schoolDetails',
              parentNavigatorKey: _schoolShellNavigatorKey,
              redirect: (BuildContext context, GoRouterState state) =>
                  RouterHelper.redirectWithToast(
                context,
                state: state,
                redirectPath: '/home/schools',
                paramKeys: ['schoolId'],
                toastMessage: 'Invalid School details',
              ),
              pageBuilder: (BuildContext context, GoRouterState state) {
                return NoTransitionPage(
                  child: SchoolDetails(
                    state.uri.queryParameters['schoolId'] ?? '',
                    state.extra != null && state.extra is SchoolViewModel
                        ? state.extra as SchoolViewModel
                        : null,
                  ),
                );
              },
              routes: [
                GoRoute(
                  parentNavigatorKey: _schoolShellNavigatorKey,
                  path: 'student',
                  name: 'student',
                  redirect: (BuildContext context, GoRouterState state) =>
                      RouterHelper.redirectWithToast(
                    context,
                    state: state,
                    redirectPath: '/home/schools',
                    paramKeys: ['schoolId', 'studentId'],
                    toastMessage: 'Invalid Student Details',
                  ),
                  builder: (context, state) {
                    return Student(
                      studentId: state.uri.queryParameters['studentId'] ?? '',
                      schoolId: state.uri.queryParameters['schoolId'] ?? '',
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
