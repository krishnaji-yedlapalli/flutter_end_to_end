
import '../../domain/entities/school_entity.dart';

class SchoolViewModel {

  SchoolViewModel(this.schoolName, this.country, this.location, this.id);

  final String schoolName;

  String id;

  final String country;

  final String location;

  factory SchoolViewModel.fromEntity(SchoolEntity school) {
    return SchoolViewModel(
        school.schoolName, school.country, school.location, school.id
    );
  }

}