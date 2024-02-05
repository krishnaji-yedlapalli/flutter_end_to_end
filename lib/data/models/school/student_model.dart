import 'package:json_annotation/json_annotation.dart';


part 'student_model.g.dart';

@JsonSerializable()
class StudentModel {

  StudentModel(this.studentName, this.className, this.location, this.id);

  @JsonKey(required: true)
  final String studentName;
  final String className;
  final String location;
  final int id;

  factory StudentModel.fromJson(Map<String, dynamic> json) => _$StudentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentModelToJson(this);
}