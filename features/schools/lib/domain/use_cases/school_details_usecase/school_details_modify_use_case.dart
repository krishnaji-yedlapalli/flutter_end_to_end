import 'package:app_core/analytics_exception_handler/exception_handler.dart';
import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import 'package:fpdart/fpdart.dart';

import '../../../shared/models/school_executed_task_model.dart';
import '../../../shared/params/school_details_param.dart';
import '../../entities/school_details_entity.dart';
import '../../repository/school_details_repository.dart';

class SchoolDetailsModifyUseCase {
  SchoolDetailsModifyUseCase(this._repository, this._executedTaskFlow);

  final SchoolDetailsRepository _repository;

  final SchoolExecutedTaskFlow _executedTaskFlow;

  Future<Either<SchoolDetailsEntity, ErrorDetails>> call(
      SchoolDetailsParams params) async {
    try {
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
      return Left(schoolDetails);
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Unable to create the School Details');
      return Right(ExceptionHandler().handleException(e, s));
    }
  }
}
