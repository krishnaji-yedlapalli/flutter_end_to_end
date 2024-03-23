import 'package:json_annotation/json_annotation.dart';


part 'student_model.g.dart';

@JsonSerializable()
class StudentModel {

  StudentModel(this.id, this.schoolId, this.studentName, this.studentLocation, this.standard, this.createdDate, {this.updatedDate});

  @JsonKey(required: true,)
  final String id;
  final String schoolId;
  final String studentName;
  final String studentLocation;
  final String standard;

  final int createdDate;

  final int? updatedDate;

  factory StudentModel.fromJson(Map<String, dynamic> json) => _$StudentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentModelToJson(this);

  Map<String, dynamic> toRouteJson() {
    var json = _$StudentModelToJson(this);
    json['createdDate'] = createdDate.toString();
    json['updatedDate'] = updatedDate.toString();
    return json;
  }

  StudentModel fromRouteJson(Map<String, dynamic> json) {
    var json = _$StudentModelToJson(this);
    json['createdDate'] = int.parse(json['createdDate']);
    json['updatedDate'] = int.parse(json['updatedDate']);

    return StudentModel.fromJson(json);
  }
}