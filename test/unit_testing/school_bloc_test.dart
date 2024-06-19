


import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/models/school/school_model.dart';
import 'package:sample_latest/services/repository/school_repository.dart';
import '../mock_data/school/mock_school_repo.dart';
import '../widget_testing/school/school_widget_test.dart';
import 'school_bloc_test.mocks.dart';

@GenerateMocks([MockSchoolRepo])
main() {

  group('School bloc test', ()  {

    late MockMockSchoolRepo mockSchoolRepo;
    late SchoolBloc schoolBloc;

    setUpAll((){
      mockSchoolRepo = MockMockSchoolRepo();
      schoolBloc = SchoolBloc(mockSchoolRepo);
    });


    blocTest<SchoolBloc, SchoolState>('loading schools',
        build: () => schoolBloc,
        act: (schoolBloc) => schoolBloc.loadSchools(),
        expect: () => [const SchoolInfoLoading(SchoolDataLoadedType.schools),
          isA<SchoolsInfoLoaded>()]
    );

    blocTest<SchoolBloc, SchoolState>('Checking details of loaded schools',
        build: () => schoolBloc,
        act: (schoolBloc) => schoolBloc.loadSchools(),
        skip: 1,
        expect: () => [
          isA<SchoolsInfoLoaded>()]
    );

    blocTest<SchoolBloc, SchoolState>('load existing students',
      build: ()=> SchoolBloc(mockSchoolRepo),
      act: (schoolBloc) => schoolBloc.loadStudents('1'),
      expect: () => <SchoolState>[const StudentsInfoLoaded(SchoolDataLoadedType.students, [], '1')],
      skip: 1
    );


  });
}