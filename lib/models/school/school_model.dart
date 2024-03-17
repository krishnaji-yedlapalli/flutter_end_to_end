import 'package:json_annotation/json_annotation.dart';

part 'school_model.g.dart';

@JsonSerializable()
class SchoolModel {
  SchoolModel(this.schoolName, this.country, this.location, this.id);

  @JsonKey(required: true)
  final String schoolName;

  @JsonKey(required: true)
  String id;

  final String country;
  final String location;

  factory SchoolModel.fromJson(Map<String, dynamic> json) =>
      _$SchoolModelFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolModelToJson(this);
}
