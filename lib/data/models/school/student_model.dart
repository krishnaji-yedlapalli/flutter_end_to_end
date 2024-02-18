import 'package:json_annotation/json_annotation.dart';


part 'student_model.g.dart';

@JsonSerializable()
class StudentModel {

  StudentModel(this.id, this.schoolId, this.studentName, this.studentLocation, this.standard);

  @JsonKey(required: true,)
  int id;
  final int schoolId;
  final String studentName;
  final String studentLocation;
  final String standard;

  factory StudentModel.fromJson(Map<String, dynamic> json) => _$StudentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentModelToJson(this);
}