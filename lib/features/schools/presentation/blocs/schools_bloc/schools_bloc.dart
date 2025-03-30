import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/analytics_exception_handler/exception_handler.dart';
import 'package:sample_latest/features/schools/presentation/blocs/schools_bloc/schools_state.dart';
import 'package:sample_latest/global_variables.dart';

import 'package:loader_overlay/loader_overlay.dart';

import '../../../domain/use_cases/schools_usecase/delete_school_usecase.dart';
import '../../../domain/use_cases/schools_usecase/school_modify_usecase.dart';
import '../../../domain/use_cases/schools_usecase/school_usecase.dart';
import '../../../shared/models/school_view_model.dart';
import '../../../shared/params/school_params.dart';

class SchoolsBloc extends Cubit<SchoolsState> {
  SchoolsBloc(
      this._schoolUseCase, this._schoolModifyUseCase, this._deleteSchoolUseCase)
      : super(const SchoolsInfoInitial());

  final SchoolsUseCase _schoolUseCase;
  final SchoolModifyUseCase _schoolModifyUseCase;
  final DeleteSchoolUseCase _deleteSchoolUseCase;

  bool _isWelcomeMessageShowed = false;

  void updateWelcomeMessageStatus(bool status){
    _isWelcomeMessageShowed = status;
  }

  Future<void> loadSchools() async {
    emit(SchoolsInfoLoading(showedWelcomeMessage: _isWelcomeMessageShowed));

    try {
      var schoolEntities = await _schoolUseCase.call();

      emit(SchoolsInfoLoaded(schoolEntities
          .map((school) => SchoolViewModel.fromEntity(school))
          .toList()));
    } catch (e, s) {
      emit(SchoolDataError(ExceptionHandler().handleException(e, s)));
    }
  }

  Future<void> createOrUpdateSchool(SchoolParams params,
      {bool isCreateSchool = false}) async {
    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      var schoolEntities =
          await _schoolModifyUseCase.call(params, isCreateSchool);

      emit(SchoolsInfoLoaded(schoolEntities
          .map((school) => SchoolViewModel.fromEntity(school))
          .toList()));
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s,
          toastMessage: isCreateSchool
              ? 'Unable to create the School'
              : 'Unable to update the school');
    } finally {
      navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }

  Future<void> deleteSchool(String schoolId) async {
    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      var schoolEntities = await _deleteSchoolUseCase.call(schoolId);

      emit(SchoolsInfoLoaded(schoolEntities
          .map((school) => SchoolViewModel.fromEntity(school))
          .toList()));
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Failed to Delete the School');
    } finally {
      navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }
}
