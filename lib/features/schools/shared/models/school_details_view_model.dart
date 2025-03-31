class SchoolDetailsViewModel {
  final String id;
  final String schoolName;
  final String country;
  final String location;
  final String image;
  final int studentCount;
  final int employeeCount;
  final bool hostelAvailability;

  SchoolDetailsViewModel({
    required this.id,
    required this.schoolName,
    required this.country,
    required this.location,
    required this.image,
    required this.studentCount,
    required this.employeeCount,
    required this.hostelAvailability,
  });

}