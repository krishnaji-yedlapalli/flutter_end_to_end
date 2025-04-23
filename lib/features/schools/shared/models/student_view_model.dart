import '../../domain/entities/student_entity.dart';

class StudentViewModel {
  final String id;
  final String schoolId;
  final String studentName;
  final String studentLocation;
  final String standard;

  StudentViewModel({
    required this.id,
    required this.schoolId,
    required this.studentName,
    required this.studentLocation,
    required this.standard,
  });

  /// Convert from StudentEntity to StudentViewModel
  factory StudentViewModel.fromEntity(StudentEntity entity) {
    return StudentViewModel(
      id: entity.id,
      schoolId: entity.schoolId,
      studentName: entity.studentName,
      studentLocation: entity.studentLocation,
      standard: entity.standard,
    );
  }
}
