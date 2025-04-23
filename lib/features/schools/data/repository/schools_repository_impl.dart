import 'package:sample_latest/core/data/urls.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:sample_latest/features/schools/domain/entities/school_entity.dart';
import 'package:sample_latest/features/schools/domain/repository/school_repository.dart';

import '../../../../core/data/base_service.dart';
import '../model/school_model.dart';

class SchoolsRepositoryImpl implements SchoolRepository {
  SchoolsRepositoryImpl(this.baseService);

  final BaseService baseService;

  @override
  Future<SchoolEntity> createOrEditSchool(SchoolEntity school) async {
    /// Creating object
    Map<String, dynamic> body = {school.id: school.toJson()};

    SchoolModel? schoolDto;
    var response = await baseService.makeRequest(
        url: '${Urls.schools}.json', body: body, method: RequestType.patch);
    if (response != null && response is Map && response.keys.isNotEmpty) {
      schoolDto = SchoolModel.fromJson(response[response.keys.first]);
    } else {
      throw UnimplementedError();
    }
    return schoolDto.toSchoolEntity();
  }

  @override
  Future<bool> deleteSchool(String schoolId) async {
    var schoolDelRes = await baseService.makeRequest(
        url: '${Urls.schools}/$schoolId.json', method: RequestType.delete);
    var schoolDetailsDelRes = await baseService.makeRequest(
        url: '${Urls.schoolDetails}/$schoolId.json',
        method: RequestType.delete);
    var studentsDel = await baseService.makeRequest(
        url: '${Urls.students}/$schoolId.json', method: RequestType.delete);
    return true;
  }

  @override
  Future<List<SchoolEntity>> fetchSchools() async {
    List<SchoolModel> schools = <SchoolModel>[];
    var response = await baseService.makeRequest(url: '${Urls.schools}.json');
    if (response is Map) {
      schools = response.entries
          .map<SchoolModel>((json) => SchoolModel.fromJson(json.value))
          .toList();
    } else if (response is List) {
      schools = response
          .map<SchoolModel>((json) => SchoolModel.fromJson(json))
          .toList();
    }

    /// Converting DTO to entities
    List<SchoolEntity> schoolEntities =
        schools.map((school) => school.toSchoolEntity()).toList();

    return schoolEntities;
  }
}
