import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sample_latest/data/models/school/school_details_model.dart';
import 'package:sample_latest/data/models/school/school_model.dart';
import 'package:sample_latest/data/models/school/student_model.dart';

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
        schools = await repository.fetchSchools();
        emit(SchoolsInfoLoaded(schoolState, schools));
      } catch (e, s) {
        emit(DataError(schoolState));
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
        emit(DataError(schoolState));
      }
    });

    on<StudentsDataEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.students;
      var state = this.state;
      // if(state is SchoolInfoLoaded){
      //   var selectedSchool = state.school;
      emit(SchoolInfoLoading(schoolState));

      try {
        students = await repository.fetchStudents(event.schoolId);
        viewAllStudents = false;
        emit(StudentsInfoLoaded(schoolState, students, event.schoolId));
      } catch (e, s) {
        emit(DataError(schoolState));
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
        emit(DataError(schoolState));
      }
      // }
    });

    on<CreateSchoolEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.schools;

      try {
        var newSchool = SchoolModel(event.schoolName, event.country,
            event.location, schools.isNotEmpty ? schools.last.id + 1 : 0);
        Map<String, dynamic> body = {
          newSchool.id.toString(): newSchool.toJson()
        };
        var createdSchool = await repository.createSchool(body);
        schools = [...schools, createdSchool];
        emit(SchoolsInfoLoaded(schoolState, schools));
      } catch (e, s) {
        emit(DataError(schoolState));
      }
    });

    on<CreateStudentEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.students;

      try {
        Map<String, dynamic> body = {
            event.student.id.toString(): event.student.toJson()
        };
        var createdStudent =
            await repository.createStudent(event.schoolId, body);
        if (createdStudent != null) {
        } else {}
        students = [...students, event.student];
        emit(StudentsInfoLoaded(schoolState, students, event.schoolId));
      } catch (e, s) {
        emit(DataError(schoolState));
      }
    });
  }
}
