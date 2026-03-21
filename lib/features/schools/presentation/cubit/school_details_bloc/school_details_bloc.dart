import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/features/schools/presentation/cubit/school_details_bloc/schools_details_state.dart';
import 'package:sample_latest/features/schools/presentation/cubit/students_bloc/students_bloc.dart';
import 'package:sample_latest/core/routing/routing_exports.dart';

import 'package:loader_overlay/loader_overlay.dart';

import '../../../domain/use_cases/use_cases.dart';
import '../../../shared/models/school_details_view_model.dart';
import '../../../shared/params/school_details_param.dart';

class SchoolDetailsBloc extends Cubit<SchoolDetailsState> {
  SchoolDetailsBloc(this._schoolDetailsUseCase,
      this._schoolDetailsModifyUseCase, this._studentsBloc)
      : super(const SchoolDetailsInitial());

  final SchoolDetailsUseCase _schoolDetailsUseCase;
  final SchoolDetailsModifyUseCase _schoolDetailsModifyUseCase;
  final StudentsBloc _studentsBloc;

  Future<void> loadSchoolDetails(String schoolId) async {
    emit(const SchoolDetailsInitialLoading());

    var result = await _schoolDetailsUseCase.call(schoolId);

    switch (result) {
      case Left(value: final schoolDetails):
        if (schoolDetails != null) {
          emit(SchoolDetailsInfoLoaded(
              SchoolDetailsViewModel.fromEntity(schoolDetails)));
        } else {
          emit(const SchoolDetailsDataNotFound());
        }
      case Right(value: final errorDetails):
        emit(SchoolDetailsDataError(errorDetails));
    }
  }

  Future<void> createOrEditSchoolDetails(
      SchoolDetailsParams schoolDetails) async {
    NavigationKeys.navigatorKey.currentContext?.loaderOverlay.show();

    var result = await _schoolDetailsModifyUseCase.call(schoolDetails);

    NavigationKeys.navigatorKey.currentContext?.loaderOverlay.hide();

    switch (result) {
      case Left(value: final entity):
        emit(
            SchoolDetailsInfoLoaded(SchoolDetailsViewModel.fromEntity(entity)));
      case _: // Error already handled in use case via toast
    }
  }
}
