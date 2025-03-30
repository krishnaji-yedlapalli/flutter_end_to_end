
import 'package:sample_latest/features/schools/domain/entities/student_entity.dart';

import '../../../shared/models/school_executed_task_model.dart';
import '../../repository/students_repository.dart';

class StudentsUseCase {
  StudentsUseCase(this._repository, this._executedTask);

  final StudentsRepository _repository;

  final SchoolExecutedTaskFlow _executedTask;

  Future<List<StudentEntity>> call(String schoolId) async {
    _executedTask.students.clear();
    var students = await _repository.fetchStudents(schoolId);
    _executedTask.students = students;
    return _executedTask.students;
  }
}
