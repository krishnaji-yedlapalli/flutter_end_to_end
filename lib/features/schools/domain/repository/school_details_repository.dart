

import '../entities/school_details_entity.dart';

abstract class SchoolDetailsRepository {

  Future<SchoolDetailsEntity?> fetchSchoolDetails(String id);
  Future<SchoolDetailsEntity> addOrEditSchoolDetails(SchoolDetailsEntity schoolDetails);

}