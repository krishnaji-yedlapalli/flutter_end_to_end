import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sample_latest/data/models/school/school_model.dart';
import 'package:sample_latest/data/models/school/student_model.dart';

import '../../data/repository/school_repository.dart';

part 'school_event.dart';
part 'school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final SchoolRepository repository;
  List<SchoolModel> schools = <SchoolModel>[];
  SchoolModel? selectedSchool;

  SchoolBloc(this.repository) : super(SchoolInfoInitial(SchoolDataLoadedType.schools)) {

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

      emit(SchoolInfoLoading(schoolState));
      try {

        var school = await repository.fetchSchoolDetails();
        selectedSchool = school;
        emit(SchoolInfoLoaded(schoolState, school));
      } catch (e, s) {
        emit(DataError(schoolState));
      }
    });

    on<StudentDataEvent>((event, emit) async {
      const schoolState = SchoolDataLoadedType.students;
      var state = this.state;
      if(state is SchoolInfoLoaded){
        var selectedSchool = state.school;
      emit(SchoolInfoLoading(schoolState));

      try {
        var student = await repository.fetchStudent();
        emit(StudentInfoLoaded(schoolState, student, selectedSchool));
      } catch (e, s) {
        emit(DataError(schoolState));
      }
      }
    });
  }
}
