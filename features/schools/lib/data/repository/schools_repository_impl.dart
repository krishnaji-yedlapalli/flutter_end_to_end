import 'package:app_core/core/data/network/network_client.dart';
import 'package:app_core/core/data/urls.dart';
import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import 'package:schools/domain/entities/entities.dart';
import 'package:schools/domain/repository/repository.dart';

import '../model/school_model.dart';

class SchoolsRepositoryImpl implements SchoolRepository {
  SchoolsRepositoryImpl(this._networkClient);

  final NetworkClient _networkClient;

  @override
  Future<SchoolEntity> createOrEditSchool(SchoolEntity school) async {
    Map<String, dynamic> body = {
      school.id: SchoolModel.fromEntity(school).toJson()
    };

    SchoolModel? schoolDto;
    final result = await _networkClient.makeRequest(
        url: Urls.schools, body: body, method: RequestType.patch);

    return result.fold(
      (failure) =>
          throw Exception(failure.message ?? 'Failed to create/edit school'),
      (response) {
        final data = response.data;
        if (data != null && data is Map && data.keys.isNotEmpty) {
          schoolDto = SchoolModel.fromJson(data[data.keys.first]);
        } else {
          throw UnimplementedError();
        }
        return schoolDto!.toSchoolEntity();
      },
    );
  }

  @override
  Future<bool> deleteSchool(String schoolId) async {
    await _networkClient.makeRequest(
        url: '${Urls.schools}/$schoolId', method: RequestType.delete);
    await _networkClient.makeRequest(
        url: '${Urls.schoolDetails}/$schoolId', method: RequestType.delete);
    await _networkClient.makeRequest(
        url: '${Urls.students}/$schoolId', method: RequestType.delete);
    return true;
  }

  @override
  Future<List<SchoolEntity>> fetchSchools() async {
    List<SchoolModel> schools = <SchoolModel>[];
    final result = await _networkClient.makeRequest(url: Urls.schools);

    return result.fold(
      (failure) =>
          throw Exception(failure.message ?? 'Failed to fetch schools'),
      (response) {
        final data = response.data;
        if (data is Map) {
          schools = data.entries
              .map<SchoolModel>((json) => SchoolModel.fromJson(json.value))
              .toList();
        } else if (data is List) {
          schools = data
              .map<SchoolModel>((json) => SchoolModel.fromJson(json))
              .toList();
        }

        /// Converting DTO to entities
        List<SchoolEntity> schoolEntities =
            schools.map((school) => school.toSchoolEntity()).toList();

        return schoolEntities;
      },
    );
  }
}
