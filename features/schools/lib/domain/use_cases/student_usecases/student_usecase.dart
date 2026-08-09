import 'package:fpdart/fpdart.dart';
import 'package:app_core/analytics_exception_handler/exception_handler.dart';
import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import 'package:schools/domain/entities/student_entity.dart';

import '../../repository/students_repository.dart';

class StudentUseCase {
  StudentUseCase(this._repository);

  final StudentsRepository _repository;

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
