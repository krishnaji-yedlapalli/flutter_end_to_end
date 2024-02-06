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

  SchoolBloc(this.repository) : super(SchoolInfoInitial(SchoolDataLoadedType.schools)) {

    on<SchoolsDataEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.schools;

      emit(SchoolInfoLoading(schoolState));
      try {
        var schools = await repository.fetchSchools();
        emit(SchoolsInfoLoaded(schoolState, schools));
      } catch (e, s) {
        emit(DataError(schoolState));
      }
    });

    on<SchoolDataEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.school;

      emit(SchoolInfoLoading(schoolState));
      try {

        var school = await repository.fetchSchoolDetails(event.id);
        emit(SchoolInfoLoaded(schoolState, school));
      } catch (e, s) {
        emit(DataError(schoolState));
      }
    });

    on<StudentsDataEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.students;
      var state = this.state;
      if(state is SchoolInfoLoaded){
        var selectedSchool = state.school;
        emit(SchoolInfoLoading(schoolState));

        try {
          var students = await repository.fetchStudents(event.schoolId);
          emit(StudentsInfoLoaded(schoolState, students, selectedSchool));
        } catch (e, s) {
          emit(DataError(schoolState));
        }
      }
    });

    on<StudentDataEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.student;
      var state = this.state;
      if(state is StudentsInfoLoaded){
        var selectedSchool = state.school;
      emit(SchoolInfoLoading(schoolState));

      try {
        var student = await repository.fetchStudent(event.studentId, event.schoolId);
        emit(StudentInfoLoaded(schoolState, student, selectedSchool));
      } catch (e, s) {
        emit(DataError(schoolState));
      }
      }
    });
  }
}
