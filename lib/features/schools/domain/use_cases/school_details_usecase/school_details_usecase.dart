import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/analytics_exception_handler/exception_handler.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:sample_latest/features/schools/shared/models/school_executed_task_model.dart';

import '../../entities/school_details_entity.dart';
import '../../repository/school_details_repository.dart';

class SchoolDetailsUseCase {
  SchoolDetailsUseCase(this._repository, this._executedTaskFlow);

  final SchoolDetailsRepository _repository;

  final SchoolExecutedTaskFlow _executedTaskFlow;

  Future<Either<SchoolDetailsEntity?, ErrorDetails>> call(
      String schoolId) async {
    try {
      var schoolDetails = await _repository.fetchSchoolDetails(schoolId);
      _executedTaskFlow.schoolDetailsEntity = schoolDetails;
      return Left(schoolDetails);
    } catch (e, s) {
      return Right(ExceptionHandler().handleException(e, s));
    }
  }
}
