import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:schools/domain/use_cases/use_cases.dart';
import 'package:schools/presentation/cubit/school_details_bloc/school_details_bloc.dart';
import 'package:schools/presentation/cubit/school_details_bloc/schools_details_state.dart';
import 'package:schools/presentation/cubit/schools_cubit/schools_cubit.dart';
import 'package:schools/presentation/cubit/students_bloc/students_bloc.dart';
import 'package:schools/presentation/cubit/students_bloc/students_state.dart'
    as students;
import 'package:schools/presentation/ui_mappers/schools_ui_mapper.dart';
import 'package:schools/shared/params/school_params.dart';

import '../../mock_data/school/school_mock_data.dart';

class MockSchoolsUseCase extends Mock implements SchoolsUseCase {}

class MockSchoolModifyUseCase extends Mock implements SchoolModifyUseCase {}

class MockDeleteSchoolUseCase extends Mock implements DeleteSchoolUseCase {}

class MockSchoolDetailsUseCase extends Mock implements SchoolDetailsUseCase {}

class MockSchoolDetailsModifyUseCase extends Mock
    implements SchoolDetailsModifyUseCase {}

class MockStudentsUseCase extends Mock implements StudentsUseCase {}

class MockStudentUseCase extends Mock implements StudentUseCase {}

class MockStudentModifyUseCase extends Mock implements StudentModifyUseCase {}

class MockDeleteStudentUseCase extends Mock implements DeleteStudentUseCase {}

class MockStudentsBloc extends Mock implements StudentsBloc {}

class FakeSchoolParams extends Fake implements SchoolParams {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeSchoolParams());
  });

  group('SchoolsCubit', () {
    late MockSchoolsUseCase mockSchoolsUseCase;
    late MockSchoolModifyUseCase mockSchoolModifyUseCase;
    late MockDeleteSchoolUseCase mockDeleteSchoolUseCase;
    late SchoolsUiMapper uiMapper;

    setUp(() {
      mockSchoolsUseCase = MockSchoolsUseCase();
      mockSchoolModifyUseCase = MockSchoolModifyUseCase();
      mockDeleteSchoolUseCase = MockDeleteSchoolUseCase();
      uiMapper = SchoolsUiMapperImp();
    });

    SchoolsCubit buildCubit() => SchoolsCubit(
          schoolsUseCase: mockSchoolsUseCase,
          schoolModifyUseCase: mockSchoolModifyUseCase,
          deleteSchoolUsecase: mockDeleteSchoolUseCase,
          uiMapper: uiMapper,
        );

    blocTest<SchoolsCubit, SchoolsState>(
      'loadSchools emits Initial then Loaded on success with empty list',
      build: buildCubit,
      setUp: () {
        when(() => mockSchoolsUseCase.call())
            .thenAnswer((_) async => const Left([]));
      },
      act: (cubit) => cubit.loadSchools(),
      expect: () => [
        isA<SchoolsInfoInitial>(),
        isA<SchoolsInfoLoaded>(),
      ],
      verify: (_) => verify(() => mockSchoolsUseCase.call()).called(1),
    );

    blocTest<SchoolsCubit, SchoolsState>(
      'loadSchools emits Initial then Loaded with schools',
      build: buildCubit,
      setUp: () {
        when(() => mockSchoolsUseCase.call())
            .thenAnswer((_) async => Left(SchoolMockData.schoolEntities));
      },
      act: (cubit) => cubit.loadSchools(),
      skip: 1,
      expect: () => [isA<SchoolsInfoLoaded>()],
      verify: (cubit) {
        final state = cubit.state;
        if (state is SchoolsInfoLoaded) {
          expect(state.schoolsUiModel.schools,
              hasLength(SchoolMockData.schoolEntities.length));
        }
      },
    );

    blocTest<SchoolsCubit, SchoolsState>(
      'loadSchools emits error on failure',
      build: buildCubit,
      setUp: () {
        when(() => mockSchoolsUseCase.call()).thenAnswer((_) async =>
            const Right(
                (DataErrorStateType.somethingWentWrong, message: null)));
      },
      act: (cubit) => cubit.loadSchools(),
      expect: () => [
        isA<SchoolsInfoInitial>(),
        isA<SchoolDataError>(),
      ],
    );

    blocTest<SchoolsCubit, SchoolsState>(
      'createOrUpdateSchool emits overlay loading then updated list',
      build: buildCubit,
      seed: () =>
          SchoolsInfoLoaded(uiMapper.convert(SchoolMockData.schoolEntities)),
      setUp: () {
        when(() => mockSchoolModifyUseCase.call(any(), any()))
            .thenAnswer((_) async => Left(SchoolMockData.schoolEntities));
      },
      act: (cubit) => cubit.createOrUpdateSchool(
          SchoolParams('NewSchool', 'India', 'Delhi', null),
          isCreateSchool: true),
      expect: () => [
        isA<SchoolsInfoOverlayLoading>(),
        isA<SchoolsInfoOverlayLoading>(),
        isA<SchoolsInfoLoaded>(),
      ],
    );

    blocTest<SchoolsCubit, SchoolsState>(
      'deleteSchool emits overlay loading then updated list',
      build: buildCubit,
      seed: () =>
          SchoolsInfoLoaded(uiMapper.convert(SchoolMockData.schoolEntities)),
      setUp: () {
        when(() => mockDeleteSchoolUseCase.call(any()))
            .thenAnswer((_) async => Left(SchoolMockData.schoolEntities));
      },
      act: (cubit) => cubit.deleteSchool('123'),
      expect: () => [
        isA<SchoolsInfoOverlayLoading>(),
        isA<SchoolsInfoOverlayLoading>(),
        isA<SchoolsInfoLoaded>(),
      ],
    );
  });

  group('SchoolDetailsBloc', () {
    late MockSchoolDetailsUseCase mockSchoolDetailsUseCase;
    late MockSchoolDetailsModifyUseCase mockSchoolDetailsModifyUseCase;

    setUp(() {
      mockSchoolDetailsUseCase = MockSchoolDetailsUseCase();
      mockSchoolDetailsModifyUseCase = MockSchoolDetailsModifyUseCase();
    });

    SchoolDetailsBloc buildBloc() => SchoolDetailsBloc(
          mockSchoolDetailsUseCase,
          mockSchoolDetailsModifyUseCase,
        );

    blocTest<SchoolDetailsBloc, SchoolDetailsState>(
      'loadSchoolDetails emits Loading then Loaded',
      build: buildBloc,
      setUp: () {
        when(() => mockSchoolDetailsUseCase.call('123'))
            .thenAnswer((_) async => Left(SchoolMockData.schoolDetailsEntity));
      },
      act: (bloc) => bloc.loadSchoolDetails('123'),
      expect: () => [
        isA<SchoolDetailsInitialLoading>(),
        isA<SchoolDetailsInfoLoaded>(),
      ],
    );

    blocTest<SchoolDetailsBloc, SchoolDetailsState>(
      'loadSchoolDetails emits NotFound when null',
      build: buildBloc,
      setUp: () {
        when(() => mockSchoolDetailsUseCase.call('123'))
            .thenAnswer((_) async => const Left(null));
      },
      act: (bloc) => bloc.loadSchoolDetails('123'),
      expect: () => [
        isA<SchoolDetailsInitialLoading>(),
        isA<SchoolDetailsDataNotFound>(),
      ],
    );

    blocTest<SchoolDetailsBloc, SchoolDetailsState>(
      'loadSchoolDetails emits error on failure',
      build: buildBloc,
      setUp: () {
        when(() => mockSchoolDetailsUseCase.call('123')).thenAnswer((_) async =>
            const Right(
                (DataErrorStateType.somethingWentWrong, message: null)));
      },
      act: (bloc) => bloc.loadSchoolDetails('123'),
      expect: () => [
        isA<SchoolDetailsInitialLoading>(),
        isA<SchoolDetailsDataError>(),
      ],
    );
  });

  group('StudentsBloc', () {
    late MockStudentsUseCase mockStudentsUseCase;
    late MockStudentUseCase mockStudentUseCase;
    late MockStudentModifyUseCase mockStudentModifyUseCase;
    late MockDeleteStudentUseCase mockDeleteStudentUseCase;

    setUp(() {
      mockStudentsUseCase = MockStudentsUseCase();
      mockStudentUseCase = MockStudentUseCase();
      mockStudentModifyUseCase = MockStudentModifyUseCase();
      mockDeleteStudentUseCase = MockDeleteStudentUseCase();
    });

    StudentsBloc buildBloc() => StudentsBloc(
          mockStudentsUseCase,
          mockStudentModifyUseCase,
          mockDeleteStudentUseCase,
          mockStudentUseCase,
        );

    blocTest<StudentsBloc, students.StudentsState>(
      'loadStudents emits Loading then Loaded with empty list',
      build: buildBloc,
      setUp: () {
        when(() => mockStudentsUseCase.call('123'))
            .thenAnswer((_) async => const Left([]));
      },
      act: (bloc) => bloc.loadStudents('123'),
      expect: () => [
        isA<students.StudentsInfoLoading>(),
        isA<students.StudentsInfoLoaded>(),
      ],
      verify: (bloc) {
        final state = bloc.state;
        if (state is students.StudentsInfoLoaded) {
          expect(state.students, isEmpty);
        }
      },
    );

    blocTest<StudentsBloc, students.StudentsState>(
      'loadStudents emits Loaded with students',
      build: buildBloc,
      setUp: () {
        when(() => mockStudentsUseCase.call('123'))
            .thenAnswer((_) async => Left(SchoolMockData.studentEntities));
      },
      act: (bloc) => bloc.loadStudents('123'),
      skip: 1,
      expect: () => [isA<students.StudentsInfoLoaded>()],
      verify: (bloc) {
        final state = bloc.state;
        if (state is students.StudentsInfoLoaded) {
          expect(
              state.students, hasLength(SchoolMockData.studentEntities.length));
        }
      },
    );

    blocTest<StudentsBloc, students.StudentsState>(
      'loadStudents emits error on failure',
      build: buildBloc,
      setUp: () {
        when(() => mockStudentsUseCase.call('123')).thenAnswer((_) async =>
            const Right(
                (DataErrorStateType.somethingWentWrong, message: null)));
      },
      act: (bloc) => bloc.loadStudents('123'),
      expect: () => [
        isA<students.StudentsInfoLoading>(),
        isA<students.SchoolDataError>(),
      ],
    );

    blocTest<StudentsBloc, students.StudentsState>(
      'loadStudent emits Loading then StudentInfoLoaded',
      build: buildBloc,
      setUp: () {
        when(() => mockStudentUseCase.call('321', '123')).thenAnswer(
            (_) async => Left(SchoolMockData.studentEntities.first));
      },
      act: (bloc) => bloc.loadStudent('321', '123'),
      expect: () => [
        isA<students.StudentsInfoLoading>(),
        isA<students.StudentInfoLoaded>(),
      ],
    );
  });
}
