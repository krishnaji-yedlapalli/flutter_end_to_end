import 'package:sample_latest/features/schools/domain/entities/student_entity.dart';

import '../../../../../core/mixins/helper_methods.dart';
import '../../../shared/models/school_executed_task_model.dart';
import '../../../shared/params/student_params.dart';
import '../../repository/students_repository.dart';

class StudentModifyUseCase {
  StudentModifyUseCase(this._repository, this._executedTask);

  final StudentsRepository _repository;

  final SchoolExecutedTaskFlow _executedTask;

  Future<List<StudentEntity>> call(StudentParams params, bool isCreate) async {
    var students = <StudentEntity>[];

    if (isCreate) {
      students = await createStudent(params);
    } else {
      students = await updateStudent(params);
    }

    return students;
  }

  Future<List<StudentEntity>> createStudent(StudentParams params) async {
    var student = StudentEntity(
      id: HelperMethods.uuid,
      schoolId: params.schoolId,
      studentName: params.studentName,
      studentLocation: params.studentLocation,
      standard: params.standard,
      createdDate: DateTime.now().millisecondsSinceEpoch,
    );

    student = await _repository.createOrEditStudent(student);

    _executedTask.students.add(student);
    return _executedTask.students;
  }

  Future<List<StudentEntity>> updateStudent(StudentParams params) async {
    var student =
        _executedTask.students.firstWhere((student) => student.id == params.id);

    student = student.copyWith(
        studentName: params.studentName,
        studentLocation: params.studentLocation,
        standard: params.standard,
        updatedDate: DateTime.now().millisecondsSinceEpoch);

    student = await _repository.createOrEditStudent(student);

    _executedTask.students = _executedTask.students
        .map((s) => s.id == student.id ? student : s)
        .toList();

    return _executedTask.students;
  }
}
