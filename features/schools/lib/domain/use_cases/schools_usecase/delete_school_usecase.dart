import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/analytics_exception_handler/exception_handler.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';

import '../../../shared/models/school_executed_task_model.dart';
import '../../entities/school_entity.dart';
import '../../repository/school_repository.dart';

class DeleteSchoolUseCase {
  DeleteSchoolUseCase(this._repository, this._executedTask);

  final SchoolRepository _repository;

  final SchoolExecutedTaskFlow _executedTask;

  Future<Either<List<SchoolEntity>, ErrorDetails>> call(String schoolId) async {
    try {
      await _repository.deleteSchool(schoolId);

      _executedTask.schools.removeWhere((s) => s.id == schoolId);

      return Left(_executedTask.schools);
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Failed to Delete the School');
      return Right(ExceptionHandler().handleException(e, s));
    }
  }
}
