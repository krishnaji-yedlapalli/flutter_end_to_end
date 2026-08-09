import 'package:app_core/core/data/network/network_client.dart';
import 'package:app_core/core/data/network/network_failure.dart';
import 'package:app_core/core/data/network/network_response.dart';
import 'package:app_core/core/data/urls.dart';
import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:schools/data/model/school_model.dart';
import 'package:schools/data/repository/school_details_repository_impl.dart';
import 'package:schools/data/repository/schools_repository_impl.dart';
import 'package:schools/data/repository/students_repository_impl.dart';
import 'package:schools/domain/entities/entities.dart';

import '../../mock_data/school/school_mock_data.dart';

class MockNetworkClient extends Mock implements NetworkClient {}

void main() {
  late MockNetworkClient mockNetworkClient;

  setUp(() {
    mockNetworkClient = MockNetworkClient();
  });

  group('SchoolsRepositoryImpl', () {
    late SchoolsRepositoryImpl repo;

    setUp(() {
      repo = SchoolsRepositoryImpl(mockNetworkClient);
    });

    test('fetchSchools returns empty list when response data is null',
        () async {
      when(() => mockNetworkClient.makeRequest(
            url: Urls.schools,
          )).thenAnswer((_) async => const Right(NetworkResponse(
            data: null,
            statusCode: 200,
            headers: {},
          )));

      final schools = await repo.fetchSchools();

      expect(schools, isA<List<SchoolEntity>>());
      expect(schools, isEmpty);
    });

    test('fetchSchools returns schools from map response', () async {
      when(() => mockNetworkClient.makeRequest(
            url: Urls.schools,
          )).thenAnswer((_) async => Right(NetworkResponse(
            data: SchoolMockData.schoolsJson,
            statusCode: 200,
            headers: {},
          )));

      final schools = await repo.fetchSchools();

      expect(schools.length, 2);
      expect(schools.first.schoolName, 'Kennedy');
    });

    test('createOrEditSchool returns updated entity', () async {
      final school = SchoolMockData.schoolEntities.first;
      final schoolModel = SchoolModel.fromEntity(school);

      when(() => mockNetworkClient.makeRequest(
            url: Urls.schools,
            body: any(named: 'body'),
            method: RequestType.patch,
          )).thenAnswer((_) async => Right(NetworkResponse(
            data: {school.id: schoolModel.toJson()},
            statusCode: 200,
            headers: {},
          )));

      final result = await repo.createOrEditSchool(school);

      expect(result.schoolName, school.schoolName);
      expect(result.id, school.id);
    });

    test('deleteSchool returns true', () async {
      const schoolId = '123';
      when(() => mockNetworkClient.makeRequest(
            url: '${Urls.schools}/$schoolId',
            method: RequestType.delete,
          )).thenAnswer((_) async => const Right(NetworkResponse(
            data: null,
            statusCode: 200,
            headers: {},
          )));
      when(() => mockNetworkClient.makeRequest(
            url: '${Urls.schoolDetails}/$schoolId',
            method: RequestType.delete,
          )).thenAnswer((_) async => const Right(NetworkResponse(
            data: null,
            statusCode: 200,
            headers: {},
          )));
      when(() => mockNetworkClient.makeRequest(
            url: '${Urls.students}/$schoolId',
            method: RequestType.delete,
          )).thenAnswer((_) async => const Right(NetworkResponse(
            data: null,
            statusCode: 200,
            headers: {},
          )));

      final result = await repo.deleteSchool(schoolId);

      expect(result, true);
    });
  });

  group('SchoolsDetailsRepositoryImpl', () {
    late SchoolsDetailsRepositoryImpl repo;

    setUp(() {
      repo = SchoolsDetailsRepositoryImpl(mockNetworkClient);
    });

    test('fetchSchoolDetails returns null when network fails', () async {
      when(() => mockNetworkClient.makeRequest(
            url: '${Urls.schoolDetails}/123',
          )).thenAnswer((_) async => const Left(NetworkFailure(
            type: DataErrorStateType.noInternet,
          )));

      final result = await repo.fetchSchoolDetails('123');

      expect(result, isNull);
    });

    test('fetchSchoolDetails returns entity when data exists', () async {
      when(() => mockNetworkClient.makeRequest(
            url: '${Urls.schoolDetails}/123',
          )).thenAnswer((_) async => Right(NetworkResponse(
            data: SchoolMockData.schoolDetails.toJson(),
            statusCode: 200,
            headers: {},
          )));

      final result = await repo.fetchSchoolDetails('123');

      expect(result, isNotNull);
      expect(result!.schoolName, 'Oxford');
    });
  });

  group('StudentsRepositoryImpl', () {
    late StudentsRepositoryImpl repo;

    setUp(() {
      repo = StudentsRepositoryImpl(mockNetworkClient);
    });

    test('fetchStudents returns empty list when network fails', () async {
      when(() => mockNetworkClient.makeRequest(
            url: '${Urls.students}/123',
          )).thenAnswer((_) async => const Left(NetworkFailure(
            type: DataErrorStateType.noInternet,
          )));

      final result = await repo.fetchStudents('123');

      expect(result, isEmpty);
    });

    test('fetchStudent returns null when network fails', () async {
      when(() => mockNetworkClient.makeRequest(
            url: '${Urls.students}/123/321',
          )).thenAnswer((_) async => const Left(NetworkFailure(
            type: DataErrorStateType.noInternet,
          )));

      final result = await repo.fetchStudent('321', '123');

      expect(result, isNull);
    });

    test('fetchStudent returns entity when data exists', () async {
      when(() => mockNetworkClient.makeRequest(
            url: '${Urls.students}/123/321',
          )).thenAnswer((_) async => Right(NetworkResponse(
            data: SchoolMockData.students.first.toJson(),
            statusCode: 200,
            headers: {},
          )));

      final result = await repo.fetchStudent('321', '123');

      expect(result, isNotNull);
      expect(result!.studentName, 'john');
    });

    test('deleteStudent returns true', () async {
      when(() => mockNetworkClient.makeRequest(
            url: '${Urls.students}/123/321',
            method: RequestType.delete,
          )).thenAnswer((_) async => const Right(NetworkResponse(
            data: null,
            statusCode: 200,
            headers: {},
          )));

      final result = await repo.deleteStudent('321', '123');

      expect(result, true);
    });
  });
}
