

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sample_latest/models/school/school_model.dart';
import 'package:sample_latest/services/base_service.dart';
import 'package:sample_latest/services/repository/school_repository.dart';
import 'package:sample_latest/services/urls.dart';

import '../../mock_data/school/school_mock_data.dart';
import 'school_repo_test.mocks.dart';

@GenerateMocks([BaseService])
void main() {

  late SchoolRepository schoolRepo;
  late MockBaseService mockBaseService;


  group('School Repository Testing', (){

    setUpAll((){
      mockBaseService = MockBaseService();
      schoolRepo = SchoolRepository(baseService: mockBaseService);
    });

    test('Fetch Empty Schools', () async {

     when(mockBaseService.makeRequest(url: '${Urls.schools}.json',
     )).thenAnswer((_) => Future.value(null));

     final schools = await schoolRepo.fetchSchools();

     expect(schools, isA<List<SchoolModel>>());

    });

    test('Fetch Existing Schools', () async {
      when(mockBaseService.makeRequest(url: '${Urls.schools}.json',
      )).thenAnswer((_) => Future.value(SchoolMockData.schoolsJson));

      final schools = await schoolRepo.fetchSchools();

      expect(schools.length, 2);
      expect(schools.first.schoolName, 'Kennedy');
    });

  });
}