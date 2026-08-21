import '../entities/app_update_result.dart';

abstract class AppUpdateRepository {
  Future<AppUpdateResult> checkForUpdate();
  Future<AppUpdateResult> checkWithSimulatedValues({
    required String osVersion,
    required String appVersion,
  });
}
