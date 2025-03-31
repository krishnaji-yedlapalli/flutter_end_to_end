
import 'package:sample_latest/features/schools/domain/entities/student_entity.dart';

abstract class StudentsRepository {

  Future<StudentEntity?> fetchStudent(String studentId, String schoolId);
  Future<List<StudentEntity>> fetchStudents(String schoolId);
  Future<StudentEntity> createOrEditStudent(StudentEntity student);
  Future<bool> deleteStudent(String studentId, String schoolId);
}