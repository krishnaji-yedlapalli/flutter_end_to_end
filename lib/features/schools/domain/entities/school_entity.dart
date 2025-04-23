import 'package:sample_latest/features/schools/data/model/school_model.dart';

class SchoolEntity {
  SchoolEntity(
      this.schoolName, this.country, this.location, this.id, this.createdDate,
      {this.updatedDate});

  final String schoolName;

  String id;

  final String country;

  final String location;

  final int createdDate;

  final int? updatedDate;

  SchoolEntity copyWith({
    String? schoolName,
    String? country,
    String? location,
    int? createdDate,
    int? updatedDate,
  }) {
    return SchoolEntity(
      schoolName ?? this.schoolName,
      country ?? this.country,
      location ?? this.location,
      id,
      createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  SchoolModel toJson() {
    return SchoolModel(schoolName, country, location, id, createdDate,
        updatedDate: updatedDate);
  }
}
