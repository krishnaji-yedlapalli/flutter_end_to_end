import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_latest/core/data/base_service.dart';
import 'package:sample_latest/core/data/urls.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:sample_latest/features/schools/data/model/school_model.dart';
import 'package:sample_latest/features/schools/data/repository/school_details_repository_impl.dart';
import 'package:sample_latest/features/schools/data/repository/schools_repository_impl.dart';
import 'package:sample_latest/features/schools/data/repository/students_repository_impl.dart';
import 'package:sample_latest/features/schools/domain/entities/entities.dart';

import '../../mock_data/school/school_mock_data.dart';

class MockBaseService extends Mock implements BaseService {}

void main() {
  late MockBaseService mockBaseService;

  setUp(() {
    mockBaseService = MockBaseService();
  });

  group('SchoolsRepositoryImpl', () {
    late SchoolsRepositoryImpl repo;

    setUp(() {
      repo = SchoolsRepositoryImpl(mockBaseService);
    });

    test('fetchSchools returns empty list when response is null', () async {
      when(() => mockBaseService.makeRequest(url: '${Urls.schools}.json'))
          .thenAnswer((_) async => null);

      final schools = await repo.fetchSchools();

      expect(schools, isA<List<SchoolEntity>>());
      expect(schools, isEmpty);
    });

    test('fetchSchools returns schools from map response', () async {
      when(() => mockBaseService.makeRequest(url: '${Urls.schools}.json'))
          .thenAnswer((_) async => SchoolMockData.schoolsJson);

      final schools = await repo.fetchSchools();

      expect(schools.length, 2);
      expect(schools.first.schoolName, 'Kennedy');
    });

    test('createOrEditSchool returns updated entity', () async {
      final school = SchoolMockData.schoolEntities.first;
      final schoolModel = SchoolModel.fromEntity(school);

      when(() => mockBaseService.makeRequest(
            url: '${Urls.schools}.json',
            body: any(named: 'body'),
            method: RequestType.patch,
          )).thenAnswer((_) async => {school.id: schoolModel.toJson()});

      final result = await repo.createOrEditSchool(school);

      expect(result.schoolName, school.schoolName);
      expect(result.id, school.id);
    });

    test('deleteSchool returns true', () async {
      const schoolId = '123';
      when(() => mockBaseService.makeRequest(
          url: '${Urls.schools}/$schoolId.json',
          method: RequestType.delete)).thenAnswer((_) async => null);
      when(() => mockBaseService.makeRequest(
          url: '${Urls.schoolDetails}/$schoolId.json',
          method: RequestType.delete)).thenAnswer((_) async => null);
      when(() => mockBaseService.makeRequest(
          url: '${Urls.students}/$schoolId.json',
          method: RequestType.delete)).thenAnswer((_) async => null);

      final result = await repo.deleteSchool(schoolId);

      expect(result, true);
    });
  });

  group('SchoolsDetailsRepositoryImpl', () {
    late SchoolsDetailsRepositoryImpl repo;

    setUp(() {
      repo = SchoolsDetailsRepositoryImpl(mockBaseService);
    });

    test('fetchSchoolDetails returns null when response is null', () async {
      when(() => mockBaseService.makeRequest(
          url: '${Urls.schoolDetails}/123.json')).thenAnswer((_) async => null);

      final result = await repo.fetchSchoolDetails('123');

      expect(result, isNull);
    });

    test('fetchSchoolDetails returns entity when data exists', () async {
      when(() => mockBaseService.makeRequest(
              url: '${Urls.schoolDetails}/123.json'))
          .thenAnswer((_) async => SchoolMockData.schoolDetails.toJson());

      final result = await repo.fetchSchoolDetails('123');

      expect(result, isNotNull);
      expect(result!.schoolName, 'Oxford');
    });
  });

  group('StudentsRepositoryImpl', () {
    late StudentsRepositoryImpl repo;

    setUp(() {
      repo = StudentsRepositoryImpl(mockBaseService);
    });

    test('fetchStudents returns empty list when response is null', () async {
      when(() => mockBaseService.makeRequest(url: '${Urls.students}/123.json'))
          .thenAnswer((_) async => null);

      final result = await repo.fetchStudents('123');

      expect(result, isEmpty);
    });

    test('fetchStudent returns null when response is null', () async {
      when(() =>
              mockBaseService.makeRequest(url: '${Urls.students}/123/321.json'))
          .thenAnswer((_) async => null);

      final result = await repo.fetchStudent('321', '123');

      expect(result, isNull);
    });

    test('fetchStudent returns entity when data exists', () async {
      when(() =>
              mockBaseService.makeRequest(url: '${Urls.students}/123/321.json'))
          .thenAnswer((_) async => SchoolMockData.students.first.toJson());

      final result = await repo.fetchStudent('321', '123');

      expect(result, isNotNull);
      expect(result!.studentName, 'john');
    });

    test('deleteStudent returns true', () async {
      when(() => mockBaseService.makeRequest(
          url: '${Urls.students}/123/321.json',
          method: RequestType.delete)).thenAnswer((_) async => null);

      final result = await repo.deleteStudent('321', '123');

      expect(result, true);
    });
  });
}
