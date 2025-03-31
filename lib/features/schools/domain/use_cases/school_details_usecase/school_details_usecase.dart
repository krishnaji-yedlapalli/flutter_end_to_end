
import 'package:sample_latest/features/schools/shared/models/school_executed_task_model.dart';

import '../../entities/school_details_entity.dart';
import '../../repository/school_details_repository.dart';

class SchoolDetailsUseCase {

  SchoolDetailsUseCase(this._repository, this._executedTaskFlow);

  final SchoolDetailsRepository _repository;

  final SchoolExecutedTaskFlow _executedTaskFlow;

  Future<SchoolDetailsEntity?> call(String schoolId) async {
    var schoolDetails = await _repository.fetchSchoolDetails(schoolId);
    _executedTaskFlow.schoolDetailsEntity = schoolDetails;
    return schoolDetails;
  }
}