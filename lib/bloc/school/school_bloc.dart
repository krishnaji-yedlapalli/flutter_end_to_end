import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sample_latest/analytics_exception_handler/exception_handler.dart';
import 'package:sample_latest/services/db/offline_handler.dart';
import 'package:sample_latest/models/school/school_details_model.dart';
import 'package:sample_latest/models/school/school_model.dart';
import 'package:sample_latest/models/school/student_model.dart';
import 'package:sample_latest/services/utils/enums.dart';
import 'package:sample_latest/global_variables.dart';
import 'package:sample_latest/mixins/helper_methods.dart';
import 'package:sample_latest/mixins/notifiers.dart';
import 'package:sample_latest/utils/enums.dart';

import '../../services/repository/school_repository.dart';
import 'package:loader_overlay/loader_overlay.dart';

part 'school_event.dart';
part 'school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {

  final SchoolRepository repository;
  bool viewAllStudents = true;
  var schools = <SchoolModel>[];
  var students = <StudentModel>[];

  SchoolBloc(this.repository)
      : super(SchoolInfoInitial(SchoolDataLoadedType.schools)) {
    on<SchoolsDataEvent>(loadSchools);

    on<SchoolDataEvent>(loadSchoolDetails);

    on<StudentsDataEvent>(loadStudents);

    on<StudentDataEvent>(loadStudent);

    on<CreateSchoolEvent>(createSchool);

    on<CreateOrEditSchoolDetailsEvent>(createOrEditSchoolDetails);

    on<CreateOrEditStudentEvent>(createOrEditStudent);

    on<DeleteSchoolEvent>(deleteSchool);

    on<DeleteStudentEvent>(deleteStudent);

    on<SyncAndDumpTheData>(syncAndDumpTheData);
  }

  Future<void> loadSchools(SchoolsDataEvent event, Emitter<SchoolState> emit) async {
    const schoolState = SchoolDataLoadedType.schools;

    emit(SchoolInfoLoading(schoolState));
    try {
      schools.clear();
      schools = await repository.fetchSchools();
      emit(SchoolsInfoLoaded(schoolState, schools));
    } catch (e, s) {
      emit(SchoolDataError(
          schoolState, ExceptionHandler().handleException(e, s)));
    }
  }

  Future<void> loadSchoolDetails(SchoolDataEvent event, Emitter<SchoolState> emit) async {
    const schoolState = SchoolDataLoadedType.school;
    students.clear();
    emit(SchoolInfoLoading(schoolState));
    try {
      var school = await repository.fetchSchoolDetails(event.id);
      if (school != null) {
        emit(SchoolInfoLoaded(schoolState, school));
      } else {
        emit(const SchoolDataNotFound(schoolState));
        add(StudentsDataEvent(event.id));
      }
    } catch (e, s) {
      emit(SchoolDataError(
          schoolState, ExceptionHandler().handleException(e, s)));
    }
  }

  Future<void> loadStudents(StudentsDataEvent event, Emitter<SchoolState> emit) async {
    const schoolState = SchoolDataLoadedType.students;

    emit(SchoolInfoLoading(schoolState));

    try {
      students = await repository.fetchStudents(event.schoolId);
      viewAllStudents = false;
      emit(StudentsInfoLoaded(schoolState, students, event.schoolId));
    } catch (e, s) {
      emit(SchoolDataError(
          schoolState, ExceptionHandler().handleException(e, s)));
    }
  }

  Future<void> loadStudent(StudentDataEvent event, Emitter<SchoolState> emit) async {
    const schoolState = SchoolDataLoadedType.student;
    var state = this.state;
    // if(state is StudentsInfoLoaded && state.school != null){
    //   SchoolDetailsModel selectedSchool = state.school!;
    emit(SchoolInfoLoading(schoolState));

    try {
      var student =
          await repository.fetchStudent(event.studentId, event.schoolId);
      emit(StudentInfoLoaded(schoolState, student, event.schoolId));
    } catch (e, s) {
      emit(SchoolDataError(
          schoolState, ExceptionHandler().handleException(e, s)));
    }
  }

  Future<void> createSchool(
      CreateSchoolEvent event, Emitter<SchoolState> emit) async {
    const schoolState = SchoolDataLoadedType.schools;

    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      String schoolId = event.id != null ? event.id! : HelperMethods.uuid;
      var newSchool = SchoolModel(
          event.schoolName, event.country, event.location, schoolId);
      Map<String, dynamic> body = {schoolId: newSchool.toJson()};
      var createdSchool = await repository.createOrEditSchool(body);
      if (event.id != null) {
        var filteredSchools = [...schools];
        var index =
            filteredSchools.indexWhere((school) => school.id == event.id);
        if (index != -1) {
          filteredSchools[index] = createdSchool;
        }
        schools = [...filteredSchools];
      } else {
        schools = [...schools, createdSchool];
      }
      emit(SchoolsInfoLoaded(schoolState, schools));
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Unable to create the School');
    } finally {
      navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }

  Future<void> createOrEditSchoolDetails(CreateOrEditSchoolDetailsEvent event, Emitter<SchoolState> emit) async {
    const schoolState = SchoolDataLoadedType.school;

    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      Map<String, dynamic> body = {
        event.schoolDetails.id.toString(): event.schoolDetails.toJson()
      };

      var createdOrEditSchoolDetails =
          await repository.addOrEditSchoolDetails(body);

      emit(SchoolInfoLoaded(schoolState, createdOrEditSchoolDetails));
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Unable to create the School Details');
    } finally {
      navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }

  Future<void> createOrEditStudent(CreateOrEditStudentEvent event, Emitter<SchoolState> emit) async {
    const schoolState = SchoolDataLoadedType.students;

    var isCreateStudent = event.student.id.trim().isEmpty;
    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      String studentId =
          !isCreateStudent ? event.student.id : HelperMethods.uuid;
      event.student.id = studentId;
      Map<String, dynamic> body = {
        studentId.toString(): event.student.toJson()
      };

      var createdStudent =
          await repository.createOrEditStudent(event.schoolId, body);
      if (createdStudent != null) {
      } else {}

      viewAllStudents = true;

      if (!isCreateStudent) {
        var filteredStudents = [...students];
        var index =
            students.indexWhere((element) => element.id == event.student.id);
        if (index != -1) {
          filteredStudents[index] = event.student;
          students = filteredStudents;
        }
      } else {
        students = [...students, event.student];
      }

      emit(StudentsInfoLoaded(schoolState, students, event.schoolId));
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

  Future<void> deleteSchool(DeleteSchoolEvent event, Emitter<SchoolState> emit) async {
    const schoolState = SchoolDataLoadedType.schools;

    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      var status = await repository.deleteSchool(event.schoolId);
      var filteredSchools = [...schools, ...<SchoolModel>[]];
      filteredSchools.removeWhere((school) => school.id == event.schoolId);
      schools = filteredSchools;
      emit(SchoolsInfoLoaded(schoolState, filteredSchools));
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Failed to Delete the School');
    } finally {
      navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }

  Future<void> deleteStudent(DeleteStudentEvent event, Emitter<SchoolState> emit) async {
    const schoolState = SchoolDataLoadedType.students;

    emit(SchoolInfoLoading(schoolState));
    try {
      navigatorKey.currentContext?.loaderOverlay.show();

      var status =
          await repository.deleteStudent(event.studentId, event.schoolId);
      if (status) {
        var filteredStudents = [...students, ...<StudentModel>[]];
        filteredStudents
            .removeWhere((student) => student.id == event.studentId);
        students = filteredStudents;
        emit(StudentsInfoLoaded(schoolState, filteredStudents, event.schoolId));
      }
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Failed to Delete the student');
    } finally {
      navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }

  Future<void> syncAndDumpTheData(SyncAndDumpTheData event, Emitter<SchoolState> emit) async {
    const schoolState = SchoolDataLoadedType.schools;

    try {
      if (event.isSyncData) {
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
