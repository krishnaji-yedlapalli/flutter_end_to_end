import '../../../shared/models/school_executed_task_model.dart';
import '../../../shared/params/school_details_param.dart';
import '../../entities/school_details_entity.dart';
import '../../repository/school_details_repository.dart';

class SchoolDetailsModifyUseCase {
  SchoolDetailsModifyUseCase(this._repository, this._executedTaskFlow);

  final SchoolDetailsRepository _repository;

  final SchoolExecutedTaskFlow _executedTaskFlow;

  Future<SchoolDetailsEntity> call(SchoolDetailsParams params) async {
    SchoolDetailsEntity? schoolDetailsEntity =
        _executedTaskFlow.schoolDetailsEntity;

    if (schoolDetailsEntity != null) {
      schoolDetailsEntity = schoolDetailsEntity.copyWith(
          schoolName: params.schoolName,
          country: params.country,
          location: params.location,
          image: params.image,
          studentCount: params.studentCount,
          employeeCount: params.employeeCount,
          hostelAvailability: params.hostelAvailability,
          updatedDate: DateTime.now().millisecondsSinceEpoch);
    } else {
      schoolDetailsEntity = SchoolDetailsEntity(
          id: params.schoolId,
          schoolName: params.schoolName,
          country: params.country,
          location: params.location,
          image: params.image,
          studentCount: params.studentCount,
          employeeCount: params.employeeCount,
          hostelAvailability: params.hostelAvailability,
          createdDate: DateTime.now().millisecondsSinceEpoch);
    }

    var schoolDetails =
        await _repository.addOrEditSchoolDetails(schoolDetailsEntity);
    _executedTaskFlow.schoolDetailsEntity = schoolDetails;
    return schoolDetails;
  }
}
