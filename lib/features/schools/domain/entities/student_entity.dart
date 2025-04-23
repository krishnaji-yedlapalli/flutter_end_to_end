import '../../data/model/student_model.dart';
import '../../shared/models/student_view_model.dart';

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

  StudentModel toModel() {
    return StudentModel(
      id,
      schoolId,
      studentName,
      studentLocation,
      standard,
      createdDate,
      updatedDate: updatedDate,
    );
  }

  /// Convert this entity to StudentViewModel
  StudentViewModel toStudentViewModel() {
    return StudentViewModel(
      id: id,
      schoolId: schoolId,
      studentName: studentName,
      studentLocation: studentLocation,
      standard: standard,
    );
  }

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
