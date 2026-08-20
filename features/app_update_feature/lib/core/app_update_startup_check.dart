import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../domain/entities/app_update_result.dart';
import '../domain/use_cases/check_app_update_use_case.dart';
import '../presentation/screens/flexible_update_dialog.dart';
import '../presentation/screens/force_update_screen.dart';
import '../presentation/screens/os_blocked_screen.dart';
import 'app_update_injection_module.dart';

/// Performs the app update check at startup and shows the appropriate screen.
///
/// Call this after Firebase Remote Config has been initialized.
class AppUpdateStartupCheck {
  AppUpdateStartupCheck._();

  /// Runs the update check and shows the appropriate UI if needed.
  ///
  /// Should be called from the home screen's initState or a post-frame callback
  /// after the navigator is ready.
  static Future<bool> performCheck(BuildContext context) async {
    AppUpdateInjectionModule.registerDependencies();

    try {
      final useCase = GetIt.instance<CheckAppUpdateUseCase>();
      final result = await useCase();

      if (!context.mounted)  return true;

      switch (result.status) {
        case AppUpdateStatus.osUnsupported:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OsBlockedScreen(result: result),
            ),
          );
          return false;
        case AppUpdateStatus.forceUpdateRequired:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ForceUpdateScreen(result: result),
            ),
          );
          return false;
        case AppUpdateStatus.flexibleUpdateAvailable:
          FlexibleUpdateDialog.show(context, result);
        case AppUpdateStatus.upToDate:
          // No action needed
          break;
      }
    } catch (e) {
      // Silently fail on startup — don't block the user from using the app
      debugPrint('AppUpdateStartupCheck failed: $e');
    }
    return true;
  }
}
