import 'package:json_annotation/json_annotation.dart';


part 'school_details_model.g.dart';

@JsonSerializable()
class SchoolDetailsModel {

  SchoolDetailsModel(this.id, this.image, this.studentCount, this.employeeCount, this.hostelAvailability, this.schoolName, this.country, this.location);

  final int id;

  @JsonKey(required: true)
  final String schoolName;

  final String country;

  final String location;

  final String image;

  final int studentCount;

  final int employeeCount;

  final String hostelAvailability;


  factory SchoolDetailsModel.fromJson(Map<String, dynamic> json) => _$SchoolDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolDetailsModelToJson(this);
}

