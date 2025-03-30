import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/analytics_exception_handler/exception_handler.dart';
import 'package:sample_latest/features/schools/presentation/blocs/students_bloc/students_state.dart';
import 'package:sample_latest/global_variables.dart';

import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../core/mixins/notifiers.dart';
import '../../../domain/use_cases/student_usecases/delete_student_usecase.dart';
import '../../../domain/use_cases/student_usecases/student_modify_usecase.dart';
import '../../../domain/use_cases/student_usecases/student_usecase.dart';
import '../../../domain/use_cases/student_usecases/students_usecase.dart';
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

    try {
      var students = await _studentsUseCase.call(schoolId);
      viewAllStudents = false;
      emit(StudentsInfoLoaded(
          students.map((s) => s.toStudentViewModel()).toList(), schoolId));
    } catch (e, s) {
      emit(SchoolDataError(ExceptionHandler().handleException(e, s)));
    }
  }

  Future<void> loadStudent(String studentId, String schoolId) async {
    emit(const StudentsInfoLoading());

    try {
      var student = await _studentUseCase.call(studentId, schoolId);

      if (student != null) {
        emit(StudentInfoLoaded(student.toStudentViewModel()));
      } else {
        navigatorKey.currentState?.pop();
        Notifiers.toastNotifier('Invalid student details');
      }
    } catch (e, s) {
      emit(SchoolDataError(ExceptionHandler().handleException(e, s)));
    }
  }

  Future<void> createOrEditStudent(StudentParams params,
      {bool isCreateStudent = false}) async {
    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      var students = await _studentModifyUseCase.call(params, isCreateStudent);

      // _viewAllStudents = true;

      emit(StudentsInfoLoaded(
          students.map((s) => s.toStudentViewModel()).toList(), params.schoolId));
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s,
          toastMessage: isCreateStudent
              ? 'Unable to create the student'
              : 'Failed to update the Student');
    } finally {
      navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }

  Future<void> deleteStudent(String studentId, String schoolId) async {
    emit(const StudentsInfoLoading());

    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      var students = await _deleteStudentUseCase.call(studentId: studentId, schoolId: schoolId);

      emit(StudentsInfoLoaded(
          students.map((s) => s.toStudentViewModel()).toList(), schoolId));
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Failed to Delete the student');
    } finally {
      navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }
}
