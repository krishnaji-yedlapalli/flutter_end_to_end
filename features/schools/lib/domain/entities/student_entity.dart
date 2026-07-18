class StudentEntity {
  final String id;
  final String schoolId;
  final String studentName;
  final String studentLocation;
  final String standard;
  final int createdDate;
  final int? updatedDate;

  const StudentEntity({
    required this.id,
    required this.schoolId,
    required this.studentName,
    required this.studentLocation,
    required this.standard,
    required this.createdDate,
    this.updatedDate,
  });

  StudentEntity copyWith({
    String? id,
    String? schoolId,
    String? studentName,
    String? studentLocation,
    String? standard,
    int? createdDate,
    int? updatedDate,
  }) {
    return StudentEntity(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      studentName: studentName ?? this.studentName,
      studentLocation: studentLocation ?? this.studentLocation,
      standard: standard ?? this.standard,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}
