import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meta/meta.dart';
import 'package:sample_latest/analytics_exception_handler/exception_handler.dart';

import 'package:sample_latest/core/data/db/offline_handler.dart';
import 'package:sample_latest/features/schools/data/model/school_details_model.dart';
import 'package:sample_latest/features/schools/data/model/school_model.dart';
import 'package:sample_latest/features/schools/data/model/student_model.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:sample_latest/global_variables.dart';

import 'package:sample_latest/core/mixins/notifiers.dart';

import '../../data/repository/school_repository.dart';
import 'package:loader_overlay/loader_overlay.dart';

part 'school_state.dart';

class SchoolBloc extends Cubit<SchoolState> {
  final SchoolRepository repository;
  bool viewAllStudents = true;
  var schools = <SchoolModel>[];
  var students = <StudentModel>[];

  bool isWelcomeMessageShowed = false;

  SchoolBloc(this.repository)
      : super(const SchoolInfoInitial(SchoolDataLoadedType.schools)) {}

  Future<void> loadSchools() async {
    const schoolState = SchoolDataLoadedType.schools;

    emit(SchoolInfoLoading(schoolState,
        showedWelcomeMessage: isWelcomeMessageShowed));

    try {
      schools.clear();
      schools = await repository.fetchSchools();
      emit(SchoolsInfoLoaded(schoolState, schools));
    } catch (e, s) {
      emit(SchoolDataError(
          schoolState, ExceptionHandler().handleException(e, s)));
    }
  }

  Future<void> loadSchoolDetails(String schoolId) async {
    const schoolState = SchoolDataLoadedType.school;

    students.clear();
    emit(const SchoolInfoLoading(schoolState));

    try {
      var school = await repository.fetchSchoolDetails(schoolId);
      if (school != null) {
        emit(SchoolInfoLoaded(schoolState, school));
      } else {
        emit(const SchoolDataNotFound(schoolState));
        loadStudents(schoolId);
      }
    } catch (e, s) {
      emit(SchoolDataError(
          schoolState, ExceptionHandler().handleException(e, s)));
    }
  }

  Future<void> loadStudents(String schoolId) async {
    const schoolState = SchoolDataLoadedType.students;

    emit(const SchoolInfoLoading(schoolState));

    try {
      students = await repository.fetchStudents(schoolId);
      viewAllStudents = false;
      emit(StudentsInfoLoaded(schoolState, students, schoolId));
    } catch (e, s) {
      emit(SchoolDataError(
          schoolState, ExceptionHandler().handleException(e, s)));
    }
  }

  Future<void> loadStudent(String studentId, String schoolId) async {
    const schoolState = SchoolDataLoadedType.student;

    emit(const SchoolInfoLoading(schoolState));

    try {
      var student = await repository.fetchStudent(studentId, schoolId);

      if (student != null) {
        emit(StudentInfoLoaded(schoolState, student, schoolId));
      } else {
        navigatorKey.currentState?.pop();
        Notifiers.toastNotifier('Invalid student details');
      }
    } catch (e, s) {
      emit(SchoolDataError(
          schoolState, ExceptionHandler().handleException(e, s)));
    }
  }

  Future<void> createOrUpdateSchool(SchoolModel school,
      {bool isCreateSchool = false}) async {
    const schoolState = SchoolDataLoadedType.schools;

    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      var createdOrUpdatedSchool = await repository.createOrEditSchool(school);

      /// cloning object
      schools = List.from(schools);

      if (!isCreateSchool) {
        var index = schools.indexWhere((school) => school.id == school.id);
        if (index != -1) {
          schools[index] = createdOrUpdatedSchool;
        }
      } else {
        schools.add(createdOrUpdatedSchool);
      }

      emit(SchoolsInfoLoaded(schoolState, schools));
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

  Future<void> createOrEditSchoolDetails(
      SchoolDetailsModel schoolDetails) async {
    const schoolState = SchoolDataLoadedType.school;

    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      var createdOrEditSchoolDetails =
          await repository.addOrEditSchoolDetails(schoolDetails);

      emit(SchoolInfoLoaded(schoolState, createdOrEditSchoolDetails));
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Unable to create the School Details');
    } finally {
      navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }

  Future<void> createOrEditStudent(StudentModel student, String schoolId,
      {bool isCreateStudent = false}) async {
    const schoolState = SchoolDataLoadedType.students;

    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      var createdStudent =
          await repository.createOrEditStudent(schoolId, student);

      viewAllStudents = true;

      students = List.from(students);
      if (!isCreateStudent) {
        var index = students.indexWhere((student) => student.id == student.id);
        if (index != -1) {
          students[index] = createdStudent;
        }
      } else {
        students.add(createdStudent);
      }

      emit(StudentsInfoLoaded(schoolState, students, schoolId));
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

  Future<void> deleteSchool(String schoolId) async {
    const schoolState = SchoolDataLoadedType.schools;

    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      var status = await repository.deleteSchool(schoolId);

      schools = List.from(schools);
      schools.removeWhere((school) => school.id == schoolId);

      emit(SchoolsInfoLoaded(schoolState, schools));
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Failed to Delete the School');
    } finally {
      navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }

  Future<void> deleteStudent(String studentId, String schoolId) async {
    const schoolState = SchoolDataLoadedType.students;

    emit(const SchoolInfoLoading(schoolState));

    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      var status = await repository.deleteStudent(studentId, schoolId);

      if (status) {
        students = List.from(students);
        students.removeWhere((student) => student.id == studentId);

        emit(StudentsInfoLoaded(schoolState, students, schoolId));
      }
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Failed to Delete the student');
    } finally {
      navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }

  Future<void> syncAndDumpTheData({bool isSyncData = false}) async {
    const schoolState = SchoolDataLoadedType.schools;

    try {
      if (isSyncData) {
        await OfflineHandler().syncData();
      } else {
        await OfflineHandler().dumpOfflineData();
      }

      emit(SchoolsInfoLoaded(schoolState, [...schools]));
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Failed to Delete the student');
    }
  }
}
