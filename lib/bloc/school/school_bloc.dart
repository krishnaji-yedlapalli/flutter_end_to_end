import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sample_latest/analytics_exception_handler/date_error_state.dart';
import 'package:sample_latest/analytics_exception_handler/exception_handler.dart';
import 'package:sample_latest/data/models/school/school_details_model.dart';
import 'package:sample_latest/data/models/school/school_model.dart';
import 'package:sample_latest/data/models/school/student_model.dart';
import 'package:sample_latest/mixins/notifiers.dart';
import 'package:sample_latest/utils/enums.dart';

import '../../data/repository/school_repository.dart';

part 'school_event.dart';
part 'school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final SchoolRepository repository;
  bool viewAllStudents = true;
  var schools = <SchoolModel>[];
  var students = <StudentModel>[];

  SchoolBloc(this.repository)
      : super(SchoolInfoInitial(SchoolDataLoadedType.schools)) {
    on<SchoolsDataEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.schools;

      emit(SchoolInfoLoading(schoolState));
      try {
        schools.clear();
        schools = await repository.fetchSchools();
        emit(SchoolsInfoLoaded(schoolState, schools));
      } catch (e, s) {
        emit(SchoolDataError(schoolState, ExceptionHandler().handleException(e, s)));
      }
    });

    on<SchoolDataEvent>((event, emit) async {
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
        emit(SchoolDataError(schoolState, ExceptionHandler().handleException(e, s)));
      }
    });

    on<StudentsDataEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.students;

      emit(SchoolInfoLoading(schoolState));

      try {
        students = await repository.fetchStudents(event.schoolId);
        viewAllStudents = false;
        emit(StudentsInfoLoaded(schoolState, students, event.schoolId));
      } catch (e, s) {
        emit(SchoolDataError(schoolState, ExceptionHandler().handleException(e, s)));
      }
      // }
    });

    on<StudentDataEvent>((event, emit) async {
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
        emit(SchoolDataError(schoolState, ExceptionHandler().handleException(e, s)));
      }
      // }
    });

    on<CreateSchoolEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.schools;

      try {
        var newSchool = SchoolModel(event.schoolName, event.country,
            event.location, event.id != null ? event.id! : schools.isNotEmpty ? schools.last.schoolId + 1 : 0);
        Map<String, dynamic> body = {
          newSchool.schoolId.toString(): newSchool.toJson()
        };
        var createdSchool = await repository.createOrEditSchool(body);
        if(event.id != null){
          var filteredSchools = [...schools];
          var index = filteredSchools.indexWhere((school) => school.schoolId == event.id);
          if(index != - 1){
            filteredSchools[index] = createdSchool;
          }
          schools = [...filteredSchools];
        }else {
          schools = [...schools, createdSchool];
        }
        emit(SchoolsInfoLoaded(schoolState, schools));
      } catch (e, s) {
        ExceptionHandler().handleExceptionWithToastNotifier(e, stackTrace: s, toastMessage:'Unable to create the student');
      }
    });

    on<CreateOrEditSchoolDetailsEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.school;

      try {

        Map<String, dynamic> body = {
          event.schoolDetails.schoolId.toString(): event.schoolDetails.toJson()
        };

        var createdOrEditSchoolDetails = await repository.addOrEditSchoolDetails(body);

        emit(SchoolInfoLoaded(schoolState, createdOrEditSchoolDetails));
      } catch (e, s) {
        ExceptionHandler().handleExceptionWithToastNotifier(e, stackTrace: s, toastMessage:'Unable to create the School Details');
      }
    });

    on<CreateOrEditStudentEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.students;

      var isCreateStudent = event.student.id == -1;
      try {
        var studentId=  !isCreateStudent ? event.student.id : students.isEmpty ? 0 : students.last.id + 1;
        event.student.id = studentId;
        Map<String, dynamic> body = {
          studentId.toString() : event.student.toJson()
        };

        var createdStudent =
            await repository.createOrEditStudent(event.schoolId, body);
        if (createdStudent != null) {

        } else {

        }

        viewAllStudents = true;

        if(!isCreateStudent){
          var filteredStudents = [...students];
          var index = students.indexWhere((element) => element.id == event.student.id);
          if(index != -1){
            filteredStudents[index] = event.student;
            students = filteredStudents;
          }
        }else{
          students = [...students, event.student];
        }

        emit(StudentsInfoLoaded(schoolState, students, event.schoolId));
      } catch (e, s) {
        ExceptionHandler().handleExceptionWithToastNotifier(e, stackTrace: s, toastMessage: isCreateStudent ? 'Unable to create the student' : 'Failed to update the Student');
      }
    });

    on<DeleteSchoolEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.schools;

      try {
        var status = await repository.deleteSchool(event.schoolId);
        var filteredSchools = [...schools, ...<SchoolModel>[]];
        filteredSchools.removeWhere((school) => school.schoolId == event.schoolId);
        emit(SchoolsInfoLoaded(schoolState, filteredSchools));
      } catch (e, s) {
        ExceptionHandler().handleExceptionWithToastNotifier(e, stackTrace: s, toastMessage: 'Failed to Delete the School');
      }
    });

    on<DeleteStudentEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.students;

      emit(SchoolInfoLoading(schoolState));
      try {
        var status = await repository.deleteStudent(event.studentId, event.schoolId);
        if(status) {
          var filteredStudents = [...students, ...<StudentModel>[]];
          filteredStudents.removeWhere((student) =>
          student.id == event.studentId);
          emit(StudentsInfoLoaded(
              schoolState, filteredStudents, event.schoolId));
        }
      } catch (e, s) {
        ExceptionHandler().handleExceptionWithToastNotifier(e, stackTrace: s, toastMessage: 'Failed to Delete the student');
      }
    });
  }


}
