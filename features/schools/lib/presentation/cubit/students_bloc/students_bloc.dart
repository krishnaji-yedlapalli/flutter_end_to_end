import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sample_latest/core/mixins/notifiers.dart';
import 'package:sample_latest/core/routing/routing_exports.dart';
import 'package:schools/presentation/cubit/students_bloc/students_state.dart';

import '../../../domain/use_cases/use_cases.dart';
import '../../../shared/models/student_view_model.dart';
import '../../../shared/params/student_params.dart';

class StudentsBloc extends Cubit<StudentsState> {
  StudentsBloc(this._studentsUseCase, this._studentModifyUseCase,
      this._deleteStudentUseCase, this._studentUseCase)
      : super(const StudentsInfoInitial());

  final StudentModifyUseCase _studentModifyUseCase;
  final StudentsUseCase _studentsUseCase;
  final StudentUseCase _studentUseCase;
  final DeleteStudentUseCase _deleteStudentUseCase;
  bool viewAllStudents = true;

  Future<void> loadStudents(String schoolId) async {
    emit(const StudentsInfoLoading());

    var result = await _studentsUseCase.call(schoolId);

    switch (result) {
      case Left(value: final students):
        viewAllStudents = false;
        emit(StudentsInfoLoaded(
            students.map((s) => StudentViewModel.fromEntity(s)).toList(),
            schoolId));
      case Right(value: final errorDetails):
        emit(SchoolDataError(errorDetails));
    }
  }

  Future<void> loadStudent(String studentId, String schoolId) async {
    emit(const StudentsInfoLoading(stateType: StudentStateType.student));

    var result = await _studentUseCase.call(studentId, schoolId);

    switch (result) {
      case Left(value: final student):
        if (student != null) {
          emit(StudentInfoLoaded(StudentViewModel.fromEntity(student),
              stateType: StudentStateType.student));
        } else {
          NavigationKeys.navigatorKey.currentState?.pop();
          Notifiers.toastNotifier('Invalid student details');
        }
      case Right(value: final errorDetails):
        emit(SchoolDataError(errorDetails));
    }
  }

  Future<void> createOrEditStudent(StudentParams params,
      {bool isCreateStudent = false}) async {
    NavigationKeys.navigatorKey.currentContext?.loaderOverlay.show();

    var result = await _studentModifyUseCase.call(params, isCreateStudent);

    NavigationKeys.navigatorKey.currentContext?.loaderOverlay.hide();

    switch (result) {
      case Left(value: final students):
        emit(StudentsInfoLoaded(
            students.map((s) => StudentViewModel.fromEntity(s)).toList(),
            params.schoolId));
      case _: // Error already handled in use case via toast
    }
  }

  Future<void> deleteStudent(String studentId, String schoolId) async {
    emit(const StudentsInfoLoading());

    NavigationKeys.navigatorKey.currentContext?.loaderOverlay.show();

    var result = await _deleteStudentUseCase.call(
        studentId: studentId, schoolId: schoolId);

    NavigationKeys.navigatorKey.currentContext?.loaderOverlay.hide();

    switch (result) {
      case Left(value: final students):
        emit(StudentsInfoLoaded(
            students.map((s) => StudentViewModel.fromEntity(s)).toList(),
            schoolId));
      case _: // Error already handled in use case via toast
    }
  }
}
