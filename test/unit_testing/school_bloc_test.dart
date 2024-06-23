import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/models/school/school_model.dart';
import 'package:sample_latest/models/school/student_model.dart';
import 'package:sample_latest/services/repository/school_repository.dart';

import '../mock_data/school/school_mock_data.dart';
import 'school_bloc_test.mocks.dart';

@GenerateMocks([SchoolRepository])
void main() {

  TestWidgetsFlutterBinding.ensureInitialized();
  late MockSchoolRepository mockSchoolRepo;

  setUp((){
    mockSchoolRepo = MockSchoolRepository();
  });

  group('School bloc test', ()  {

    blocTest<SchoolBloc, SchoolState>('loading empty schools',
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

    blocTest<SchoolBloc, SchoolState>('Loading bunch of schools',
        build: () => SchoolBloc(mockSchoolRepo),
        setUp: (){
          when(mockSchoolRepo.fetchSchools()).thenAnswer((value) {
            return Future.value(SchoolMockData.schools);
          });
        },
        act: (schoolBloc) => schoolBloc.loadSchools(),
        skip: 1,
        expect: () => [
          isA<SchoolsInfoLoaded>(),
        ],
      verify: (bloc) {
      var state = bloc.state;
       if(state is SchoolsInfoLoaded){
         expect(state.schools, hasLength(SchoolMockData.schools.length));
       }
      }
    );

    blocTest<SchoolBloc, SchoolState>('loading schools with error message',
        build: () => SchoolBloc(mockSchoolRepo),
        setUp: (){
          when(mockSchoolRepo.fetchSchools()).thenAnswer((value) {
            return Future.value(throw Exception());
          });
        },
        act: (schoolBloc) => schoolBloc.loadSchools(),
        expect: () => [const SchoolInfoLoading(SchoolDataLoadedType.schools),
          isA<SchoolDataError>(),
        ],
        verify:  (bloc){
          verify(mockSchoolRepo.fetchSchools()).called(1);
        }
    );

    blocTest<SchoolBloc, SchoolState>('Create a school',
        build: () => SchoolBloc(mockSchoolRepo),
        setUp: (){
          when(mockSchoolRepo.createOrEditSchool(any)).thenAnswer((value) => Future.value(SchoolModel('Kennedy', 'India', 'Hyderabad', '52a29100b99c1023a3674150b7ab5f7b', 1718168534634)));
        },
        act: (schoolBloc) => schoolBloc.createOrUpdateSchool(SchoolModel('Kennedy', 'India', 'Hyderabad', '52a29100b99c1023a3674150b7ab5f7b', 1718168534634)),
        // skip: 1,
        expect: () => [
          isA<SchoolsInfoLoaded>(),
        ],
      verify: (bloc) {
        verify(mockSchoolRepo.createOrEditSchool(any)).called(1);
      }
    );

    blocTest<SchoolBloc, SchoolState>('Handle error while creating a school',
        build: () => SchoolBloc(mockSchoolRepo),
        setUp: (){
          when(mockSchoolRepo.createOrEditSchool(any)).thenAnswer((value) => throw Exception());
        },
        act: (schoolBloc) => schoolBloc.createOrUpdateSchool(SchoolModel('Kennedy', 'India', 'Hyderabad', '52a29100b99c1023a3674150b7ab5f7b', 1718168534634)),
        skip: 1,
        expect: () => [

        ]
    );

    blocTest<SchoolBloc, SchoolState>('load empty students',
      build: ()=> SchoolBloc(mockSchoolRepo),
      setUp: () {
        when(mockSchoolRepo.fetchStudents('1')).thenAnswer((value) => Future.value(<StudentModel>[]));
      },
      act: (schoolBloc) => schoolBloc.loadStudents('1'),
      expect: () => <SchoolState>[const StudentsInfoLoaded(SchoolDataLoadedType.students, [], '1')],
      skip: 1
    );

    blocTest<SchoolBloc, SchoolState>('load existing students',
        build: ()=> SchoolBloc(mockSchoolRepo),
        setUp: () {
          when(mockSchoolRepo.fetchStudents('1')).thenAnswer((value) => Future.value(SchoolMockData.students));
        },
        act: (schoolBloc) => schoolBloc.loadStudents('1'),
        expect: () => [isA<StudentsInfoLoaded>()],
        skip: 1,
    );

    blocTest<SchoolBloc, SchoolState>('Create New Student',
      build: ()=> SchoolBloc(mockSchoolRepo),
      setUp: () {
        when(mockSchoolRepo.createOrEditStudent(any, any)).thenAnswer((value) => Future.value(SchoolMockData.individualStudent));
      },
      act: (schoolBloc) => schoolBloc.createOrEditStudent(SchoolMockData.individualStudent, '1', isCreateStudent: true),
      expect: () => [isA<StudentsInfoLoaded>()],
      verify: (bloc){
      var state = bloc.state;
       if(state is StudentsInfoLoaded){
         print(state.students);
         expect(state.students, hasLength(1));
       }
      }
    );

    blocTest<SchoolBloc, SchoolState>('',
      build: ()=> SchoolBloc(mockSchoolRepo),
      setUp: () {
        when(mockSchoolRepo.fetchStudents('1')).thenAnswer((value) => Future.value(SchoolMockData.students));
      },
      act: (schoolBloc) => schoolBloc.loadStudents('1'),
      expect: () => [isA<StudentsInfoLoaded>()],
      skip: 1,
    );
  });

}