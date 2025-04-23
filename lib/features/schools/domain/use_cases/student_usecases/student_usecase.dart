import 'package:sample_latest/features/schools/domain/entities/student_entity.dart';

import '../../../shared/models/school_executed_task_model.dart';
import '../../repository/students_repository.dart';

class StudentUseCase {
  StudentUseCase(this._repository, this._executedTask);

  final StudentsRepository _repository;

  final SchoolExecutedTaskFlow _executedTask;

  Future<StudentEntity?> call(String studentId, String schoolId) async {
    var student = await _repository.fetchStudent(studentId, schoolId);
    return student;
  }
}
