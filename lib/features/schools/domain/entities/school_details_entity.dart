class SchoolDetailsEntity {
  final String id;
  final String schoolName;
  final String country;
  final String location;
  final String image;
  final int studentCount;
  final int employeeCount;
  final bool hostelAvailability;
  final int createdDate;
  final int? updatedDate;

  SchoolDetailsEntity({
    required this.id,
    required this.schoolName,
    required this.country,
    required this.location,
    required this.image,
    required this.studentCount,
    required this.employeeCount,
    required this.hostelAvailability,
    required this.createdDate,
    this.updatedDate,
  });

  SchoolDetailsEntity copyWith({
    String? id,
    String? schoolName,
    String? country,
    String? location,
    String? image,
    int? studentCount,
    int? employeeCount,
    bool? hostelAvailability,
    int? createdDate,
    int? updatedDate,
  }) {
    return SchoolDetailsEntity(
      id: id ?? this.id,
      schoolName: schoolName ?? this.schoolName,
      country: country ?? this.country,
      location: location ?? this.location,
      image: image ?? this.image,
      studentCount: studentCount ?? this.studentCount,
      employeeCount: employeeCount ?? this.employeeCount,
      hostelAvailability: hostelAvailability ?? this.hostelAvailability,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}
