import 'package:sample_latest/features/schools/domain/entities/school_details_entity.dart';
import 'package:sample_latest/features/schools/domain/entities/school_entity.dart';
import 'package:sample_latest/features/schools/domain/entities/student_entity.dart';

/// This will store the information of executed school info
class SchoolExecutedTaskFlow {
  var schools = <SchoolEntity>[];

  SchoolDetailsEntity? schoolDetailsEntity;

  var students = <StudentEntity>[];
}
