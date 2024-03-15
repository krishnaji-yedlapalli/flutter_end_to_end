import 'package:json_annotation/json_annotation.dart';


part 'school_details_model.g.dart';

@JsonSerializable()
class SchoolDetailsModel {

  SchoolDetailsModel(this.id, this.schoolName, this.country, this.location, this.image, this.studentCount, this.employeeCount, this.hostelAvailability);

  String id;

  @JsonKey(required: true)
  final String schoolName;

  final String country;

  final String location;

  final String image;

  final int studentCount;

  final int employeeCount;

  final bool hostelAvailability;


  factory SchoolDetailsModel.fromJson(Map<String, dynamic> json) => _$SchoolDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolDetailsModelToJson(this);
}

