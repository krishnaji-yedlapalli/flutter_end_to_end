import 'package:app_core/core/data/network/network_client.dart';
import 'package:app_core/core/data/urls.dart';
import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repository/repository.dart';
import '../model/school_details_model.dart';

class SchoolsDetailsRepositoryImpl implements SchoolDetailsRepository {
  SchoolsDetailsRepositoryImpl(this._networkClient);

  final NetworkClient _networkClient;

  @override
  Future<SchoolDetailsEntity?> fetchSchoolDetails(String id) async {
    SchoolDetailsEntity? schoolDetails;
    final result =
        await _networkClient.makeRequest(url: '${Urls.schoolDetails}/$id');

    return result.fold(
      (failure) => null,
      (response) {
        final data = response.data;
        if (data != null) {
          schoolDetails = SchoolDetailsModel.fromJson(data).toEntity();
        }
        return schoolDetails;
      },
    );
  }

  @override
  Future<SchoolDetailsEntity> addOrEditSchoolDetails(
      SchoolDetailsEntity schoolDetails) async {
    Map<String, dynamic> body = {
      schoolDetails.id: SchoolDetailsModel.fromEntity(schoolDetails).toJson()
    };

    final result = await _networkClient.makeRequest(
        url: Urls.schoolDetails, body: body, method: RequestType.patch);

    return result.fold(
      (failure) => throw Exception(
          failure.message ?? 'Failed to add/edit school details'),
      (response) {
        final data = response.data;
        if (data != null && data is Map && data.keys.isNotEmpty) {
          schoolDetails =
              SchoolDetailsModel.fromJson(data[data.keys.first]).toEntity();
        } else {
          throw UnimplementedError();
        }
        return schoolDetails;
      },
    );
  }
}
