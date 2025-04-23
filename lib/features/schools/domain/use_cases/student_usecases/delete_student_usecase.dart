import 'package:sample_latest/features/schools/domain/entities/student_entity.dart';

import '../../../shared/models/school_executed_task_model.dart';
import '../../repository/students_repository.dart';

class DeleteStudentUseCase {
  DeleteStudentUseCase(this._repository, this._executedTask);

  final StudentsRepository _repository;

  final SchoolExecutedTaskFlow _executedTask;

  Future<List<StudentEntity>> call(
      {required String studentId, required String schoolId}) async {
    await _repository.deleteStudent(studentId, schoolId);
    _executedTask.students.removeWhere((s) => s.id == studentId);

    return _executedTask.students;
  }
}
