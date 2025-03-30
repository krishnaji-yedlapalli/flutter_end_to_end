import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/analytics_exception_handler/exception_handler.dart';
import 'package:sample_latest/features/schools/presentation/blocs/school_details_bloc/schools_details_state.dart';
import 'package:sample_latest/features/schools/presentation/blocs/students_bloc/students_bloc.dart';
import 'package:sample_latest/global_variables.dart';

import 'package:loader_overlay/loader_overlay.dart';

import '../../../domain/use_cases/school_details_usecase/school_details_modify_useCase.dart';
import '../../../domain/use_cases/school_details_usecase/school_details_usecase.dart';
import '../../../shared/params/school_details_param.dart';

class SchoolDetailsBLoc extends Cubit<SchoolDetailsState> {
  SchoolDetailsBLoc(
      this._schoolDetailsUseCase, this._schoolDetailsModifyUseCase, this._studentsBloc)
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
      emit(SchoolDetailsDataError(
          ExceptionHandler().handleException(e, s)));
    }
  }


  Future<void> createOrEditSchoolDetails(SchoolDetailsParams schoolDetails) async {

    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      var createdOrEditSchoolDetails =
      await _schoolDetailsModifyUseCase.call(schoolDetails);

      emit(SchoolDetailsInfoLoaded(createdOrEditSchoolDetails.toViewModel()));

    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Unable to create the School Details');
    } finally {
      navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }

}
