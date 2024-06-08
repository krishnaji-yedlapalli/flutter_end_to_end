


import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/models/school/school_model.dart';
import 'package:sample_latest/services/repository/school_repository.dart';

class MockSchoolRepo extends Mock implements SchoolRepository {}

main() {

  var schoolRepo = MockSchoolRepo();

  group('School bloc test', (){

    blocTest<SchoolBloc, SchoolState>('load schools',
        build: ()=> SchoolBloc(schoolRepo),
        act: (schoolBloc) => schoolBloc.loadSchools(),
        // setUp: (){
        //   when(()=> schoolRepo.fetchSchools()).thenAnswer(Future.value(
        //   //         () async {
        //   //   return <SchoolModel>[SchoolModel('Oxford', 'India', 'Hyd', '32324343243', 23322)];
        //   // });
        // },
        expect: () => <SchoolState>[SchoolInfoLoading(SchoolDataLoadedType.schools), SchoolsInfoLoaded(SchoolDataLoadedType.schools, [SchoolModel('Oxford', 'India', 'Hyd', '32324343243', 23322)])],
    );

    blocTest<SchoolBloc, SchoolState>('load existing students',
      build: ()=> SchoolBloc(schoolRepo),
      act: (schoolBloc) => schoolBloc.loadStudents('1'),
      expect: () => <SchoolState>[const StudentsInfoLoaded(SchoolDataLoadedType.students, [], '1')],
      skip: 1
    );


  });
}