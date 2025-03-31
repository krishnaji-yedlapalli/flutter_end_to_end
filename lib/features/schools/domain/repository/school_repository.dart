
import 'package:sample_latest/features/schools/domain/entities/school_entity.dart';

abstract class SchoolRepository {

  Future<List<SchoolEntity>> fetchSchools();
  Future<SchoolEntity> createOrEditSchool(SchoolEntity school);
  Future<bool> deleteSchool(String schoolId);

}