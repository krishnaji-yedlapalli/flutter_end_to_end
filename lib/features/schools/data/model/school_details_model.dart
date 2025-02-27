import 'package:json_annotation/json_annotation.dart';


part 'school_details_model.g.dart';

@JsonSerializable()
class SchoolDetailsModel {

  SchoolDetailsModel(this.id, this.schoolName, this.country, this.location, this.image, this.studentCount, this.employeeCount, this.hostelAvailability, this.createdDate, {this.updatedDate});

  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  final String schoolName;

  final String country;

  final String location;

  final String image;

  final int studentCount;

  final int employeeCount;

  final bool hostelAvailability;

  final int createdDate;

  final int? updatedDate;


  factory SchoolDetailsModel.fromJson(Map<String, dynamic> json) => _$SchoolDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolDetailsModelToJson(this);

  Map<String, dynamic> toRouteJson() {
    var json = _$SchoolDetailsModelToJson(this);
    json['createdDate'] = createdDate.toString();
    json['updatedDate'] = updatedDate.toString();
    return json;
  }

  SchoolDetailsModel fromRouteJson(Map<String, dynamic> json) {
    var json = _$SchoolDetailsModelToJson(this);
    json['createdDate'] = int.parse(json['createdDate']);
    json['updatedDate'] = int.parse(json['updatedDate']);

    return SchoolDetailsModel.fromJson(json);
  }
}

