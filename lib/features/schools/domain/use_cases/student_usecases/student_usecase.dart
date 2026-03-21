import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/analytics_exception_handler/exception_handler.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:sample_latest/features/schools/domain/entities/student_entity.dart';

import '../../../shared/models/school_executed_task_model.dart';
import '../../repository/students_repository.dart';

class StudentUseCase {
  StudentUseCase(this._repository, this._executedTask);

  final StudentsRepository _repository;

  final SchoolExecutedTaskFlow _executedTask;

  Future<Either<StudentEntity?, ErrorDetails>> call(
      String studentId, String schoolId) async {
    try {
      var student = await _repository.fetchStudent(studentId, schoolId);
      return Left(student);
    } catch (e, s) {
      return Right(ExceptionHandler().handleException(e, s));
    }
  }
}
