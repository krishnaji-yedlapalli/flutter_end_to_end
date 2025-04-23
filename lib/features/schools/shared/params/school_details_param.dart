class SchoolDetailsParams {
  SchoolDetailsParams(
      this.schoolName,
      this.country,
      this.location,
      this.id,
      this.image,
      this.studentCount,
      this.employeeCount,
      this.hostelAvailability,
      this.schoolId);

  final String schoolName;

  final String? id;

  final String schoolId;

  final String country;

  final String location;

  final String image;

  final int studentCount;

  final int employeeCount;

  final bool hostelAvailability;
}
