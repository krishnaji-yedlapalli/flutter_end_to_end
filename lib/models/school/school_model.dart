import 'package:json_annotation/json_annotation.dart';

part 'school_model.g.dart';

@JsonSerializable()
class SchoolModel {
  SchoolModel(this.schoolName, this.country, this.location, this.id, this.createdDate, {this.updatedDate});

  @JsonKey(required: true)
  final String schoolName;

  @JsonKey(required: true)
  String id;

  final String country;
  final String location;

  final int createdDate;

  final int? updatedDate;

  factory SchoolModel.fromJson(Map<String, dynamic> json) =>
      _$SchoolModelFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolModelToJson(this);

  Map<String, dynamic> toRouteJson() {
    var json = _$SchoolModelToJson(this);
    json['createdDate'] = createdDate.toString();
    json['updatedDate'] = updatedDate.toString();
    return json;
  }

  factory SchoolModel.fromRouteJson(Map<String, dynamic> json) {
    json['createdDate'] = int.parse(json['createdDate']);
    json['updatedDate'] = int.parse(json['updatedDate']);

    return SchoolModel.fromJson(json);
  }
}
