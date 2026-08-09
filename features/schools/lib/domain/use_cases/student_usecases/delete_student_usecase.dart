import 'package:fpdart/fpdart.dart';
import 'package:app_core/analytics_exception_handler/exception_handler.dart';
import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import 'package:schools/domain/entities/student_entity.dart';

import '../../../shared/models/school_executed_task_model.dart';
import '../../repository/students_repository.dart';

class DeleteStudentUseCase {
  DeleteStudentUseCase(this._repository, this._executedTask);

  final StudentsRepository _repository;

  final SchoolExecutedTaskFlow _executedTask;

  Future<Either<List<StudentEntity>, ErrorDetails>> call(
      {required String studentId, required String schoolId}) async {
    try {
      await _repository.deleteStudent(studentId, schoolId);
      _executedTask.students.removeWhere((s) => s.id == studentId);
      return Left(_executedTask.students);
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Failed to Delete the student');
      return Right(ExceptionHandler().handleException(e, s));
    }
  }
}
