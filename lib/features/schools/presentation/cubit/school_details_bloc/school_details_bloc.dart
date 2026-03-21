import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/analytics_exception_handler/exception_handler.dart';
import 'package:sample_latest/features/schools/presentation/cubit/school_details_bloc/schools_details_state.dart';
import 'package:sample_latest/features/schools/presentation/cubit/students_bloc/students_bloc.dart';
import 'package:sample_latest/core/routing/routing_exports.dart';

import 'package:loader_overlay/loader_overlay.dart';

import '../../../domain/use_cases/use_cases.dart';
import '../../../shared/params/school_details_param.dart';

class SchoolDetailsBLoc extends Cubit<SchoolDetailsState> {
  SchoolDetailsBLoc(this._schoolDetailsUseCase,
      this._schoolDetailsModifyUseCase, this._studentsBloc)
      : super(const SchoolDetailsInitial());

  final SchoolDetailsUseCase _schoolDetailsUseCase;
  final SchoolDetailsModifyUseCase _schoolDetailsModifyUseCase;
  final StudentsBloc _studentsBloc;

  Future<void> loadSchoolDetails(String schoolId) async {
    emit(const SchoolDetailsInitialLoading());

    try {
      var schoolDetails = await _schoolDetailsUseCase.call(schoolId);

      if (schoolDetails != null) {
        emit(SchoolDetailsInfoLoaded(schoolDetails.toViewModel()));
      } else {
        emit(const SchoolDetailsDataNotFound());
      }
    } catch (e, s) {
      emit(SchoolDetailsDataError(ExceptionHandler().handleException(e, s)));
    }
  }

  Future<void> createOrEditSchoolDetails(
      SchoolDetailsParams schoolDetails) async {
    try {
      NavigationKeys.navigatorKey.currentContext?.loaderOverlay.show();

      var createdOrEditSchoolDetails =
          await _schoolDetailsModifyUseCase.call(schoolDetails);

      emit(SchoolDetailsInfoLoaded(createdOrEditSchoolDetails.toViewModel()));
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Unable to create the School Details');
    } finally {
      NavigationKeys.navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }
}
