import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/models/school/school_model.dart';
import 'package:sample_latest/services/repository/school_repository.dart';

import 'school_bloc_test.mocks.dart';

@GenerateMocks([SchoolRepository])
void main() {

  late MockSchoolRepository mockSchoolRepo;

  setUp((){
    mockSchoolRepo = MockSchoolRepository();
  });

  group('School bloc test', ()  {

    blocTest<SchoolBloc, SchoolState>('loading schools',
        build: () => SchoolBloc(mockSchoolRepo),
        setUp: (){
          when(mockSchoolRepo.fetchSchools()).thenAnswer((value) {
            return Future.value(<SchoolModel>[]);
          });
        },
        act: (schoolBloc) => schoolBloc.loadSchools(),
        expect: () => [const SchoolInfoLoading(SchoolDataLoadedType.schools),
          isA<SchoolsInfoLoaded>(),
        ],
      verify:  (bloc){
        verify(mockSchoolRepo.fetchSchools()).called(1);
      }
    );

    // verify(mockSchoolRepo.fetchSchools()).called(1);


    blocTest<SchoolBloc, SchoolState>('Checking details of loaded schools',
        build: () => SchoolBloc(mockSchoolRepo),
        setUp: (){
          when(mockSchoolRepo.fetchSchools()).thenAnswer((value) {
            return Future.value(<SchoolModel>[]);
          });
        },
        act: (schoolBloc) => schoolBloc.loadSchools(),
        skip: 1,
        expect: () => [
          isA<SchoolsInfoLoaded>(),
        ]
    );

    // blocTest<SchoolBloc, SchoolState>('load existing students',
    //   build: ()=> SchoolBloc(mockSchoolRepo),
    //   act: (schoolBloc) => schoolBloc.loadStudents('1'),
    //   expect: () => <SchoolState>[const StudentsInfoLoaded(SchoolDataLoadedType.students, [], '1')],
    //   skip: 1
    // );
  });

}