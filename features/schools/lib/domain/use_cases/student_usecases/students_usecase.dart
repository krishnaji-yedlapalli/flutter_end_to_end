import 'package:fpdart/fpdart.dart';
import 'package:app_core/analytics_exception_handler/exception_handler.dart';
import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import 'package:schools/domain/entities/student_entity.dart';

import '../../../shared/models/school_executed_task_model.dart';
import '../../repository/students_repository.dart';

class StudentsUseCase {
  StudentsUseCase(this._repository, this._executedTask);

  final StudentsRepository _repository;

  final SchoolExecutedTaskFlow _executedTask;

  Future<Either<List<StudentEntity>, ErrorDetails>> call(
      String schoolId) async {
    try {
      _executedTask.students.clear();
      var students = await _repository.fetchStudents(schoolId);
      _executedTask.students = students;
      return Left(_executedTask.students);
    } catch (e, s) {
      return Right(ExceptionHandler().handleException(e, s));
    }
  }
}
