import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/analytics_exception_handler/exception_handler.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';

import '../../../shared/models/school_executed_task_model.dart';
import '../../entities/school_entity.dart';
import '../../repository/school_repository.dart';

class SchoolsUseCase {
  SchoolsUseCase(this._repository, this._executedTask);

  final SchoolRepository _repository;

  final SchoolExecutedTaskFlow _executedTask;

  Future<Either<List<SchoolEntity>, ErrorDetails>> call() async {
    try {
      var schools = await _repository.fetchSchools();
      _executedTask.schools = schools;
      return Left(schools);
    } catch (e, s) {
      return Right(ExceptionHandler().handleException(e, s));
    }
  }
}
