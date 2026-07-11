import 'package:sample_latest/core/data/base_service.dart';
import 'package:sample_latest/core/data/urls.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repository/repository.dart';
import '../model/school_details_model.dart';

class SchoolsDetailsRepositoryImpl implements SchoolDetailsRepository {
  SchoolsDetailsRepositoryImpl(this.baseService);

  final BaseService baseService;

  @override
  Future<SchoolDetailsEntity?> fetchSchoolDetails(String id) async {
    SchoolDetailsEntity? schoolDetails;
    var response =
        await baseService.makeRequest(url: '${Urls.schoolDetails}/$id.json');
    if (response != null) {
      schoolDetails = SchoolDetailsModel.fromJson(response).toEntity();
    }
    return schoolDetails;
  }

  @override
  Future<SchoolDetailsEntity> addOrEditSchoolDetails(
      SchoolDetailsEntity schoolDetails) async {
    Map<String, dynamic> body = {
      schoolDetails.id: SchoolDetailsModel.fromEntity(schoolDetails).toJson()
    };

    var response = await baseService.makeRequest(
        url: '${Urls.schoolDetails}.json',
        body: body,
        method: RequestType.patch);
    if (response != null && response is Map && response.keys.isNotEmpty) {
      schoolDetails =
          SchoolDetailsModel.fromJson(response[response.keys.first]).toEntity();
    } else {
      throw UnimplementedError();
    }
    return schoolDetails;
  }
}
