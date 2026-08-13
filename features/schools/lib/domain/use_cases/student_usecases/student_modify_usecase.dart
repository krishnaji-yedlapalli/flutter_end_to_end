import 'package:app_core/analytics_exception_handler/exception_handler.dart';
import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import 'package:app_core/core/mixins/helper_methods.dart';
import 'package:fpdart/fpdart.dart';
import 'package:schools/domain/entities/student_entity.dart';

import '../../../shared/models/school_executed_task_model.dart';
import '../../../shared/params/student_params.dart';
import '../../repository/students_repository.dart';

class StudentModifyUseCase {
  StudentModifyUseCase(this._repository, this._executedTask);

  final StudentsRepository _repository;

  final SchoolExecutedTaskFlow _executedTask;

  Future<Either<List<StudentEntity>, ErrorDetails>> call(
      StudentParams params, bool isCreate) async {
    try {
      var students = <StudentEntity>[];

      if (isCreate) {
        students = await createStudent(params);
      } else {
        students = await updateStudent(params);
      }

      return Left(students);
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s,
          toastMessage: isCreate
              ? 'Unable to create the student'
              : 'Failed to update the Student');
      return Right(ExceptionHandler().handleException(e, s));
    }
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
