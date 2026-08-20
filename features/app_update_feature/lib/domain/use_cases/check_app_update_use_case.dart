import '../entities/app_update_result.dart';
import '../repository/app_update_repository.dart';

class CheckAppUpdateUseCase {
  final AppUpdateRepository _repository;

  CheckAppUpdateUseCase(this._repository);

  Future<AppUpdateResult> call() => _repository.checkForUpdate();

  Future<AppUpdateResult> callWithSimulated({
    required String osVersion,
    required String appVersion,
  }) =>
      _repository.checkWithSimulatedValues(
        osVersion: osVersion,
        appVersion: appVersion,
      );
}
