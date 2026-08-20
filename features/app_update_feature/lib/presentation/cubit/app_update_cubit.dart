import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/check_app_update_use_case.dart';
import 'app_update_state.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  final CheckAppUpdateUseCase _useCase;

  AppUpdateCubit(this._useCase) : super(AppUpdateInitial());

  Future<void> checkForUpdate() async {
    emit(AppUpdateLoading());
    try {
      final result = await _useCase();
      emit(AppUpdateChecked(result));
    } catch (e) {
      emit(AppUpdateError(e.toString()));
    }
  }

  Future<void> checkWithSimulatedValues({
    required String osVersion,
    required String appVersion,
  }) async {
    emit(AppUpdateLoading());
    try {
      final result = await _useCase.callWithSimulated(
        osVersion: osVersion,
        appVersion: appVersion,
      );
      emit(AppUpdateChecked(result));
    } catch (e) {
      emit(AppUpdateError(e.toString()));
    }
  }
}
