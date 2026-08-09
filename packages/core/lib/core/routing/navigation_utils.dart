import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation utility functions that don't depend on specific route definitions.
class NavigationUtils {
  /// Pops routes until the home/schools route and then pops once more.
  static bool navigateToHome(BuildContext context) {
    var route = GoRouter.of(context);
    while (route.canPop()) {
      if (route.routerDelegate.currentConfiguration.uri.path ==
          '/home/schools') {
        route.pop();
        break;
      }
      route.pop();
    }
    return true;
  }
}
