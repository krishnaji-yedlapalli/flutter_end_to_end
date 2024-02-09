import 'package:json_annotation/json_annotation.dart';


part 'student_model.g.dart';

@JsonSerializable()
class StudentModel {

  StudentModel(this.id, this.studentName, this.className, this.studentStrength, this.staffStrength, this.studentLocation, this.hostelAvailability, this.standard);

  @JsonKey(required: true)
  final int id;
  final String studentName;
  final String className;
  final int studentStrength;
  final int staffStrength;
  final String studentLocation;
  final bool hostelAvailability;
  final String standard;

  factory StudentModel.fromJson(Map<String, dynamic> json) => _$StudentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentModelToJson(this);
}