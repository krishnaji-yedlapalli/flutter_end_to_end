// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchoolModel _$SchoolModelFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['schoolName', 'id'],
  );
  return SchoolModel(
    json['schoolName'] as String,
    json['country'] as String,
    json['location'] as String,
    json['id'] as String,
    json['createdDate'] as int,
    updatedDate: json['updatedDate'] as int?,
  );
}

Map<String, dynamic> _$SchoolModelToJson(SchoolModel instance) =>
    <String, dynamic>{
      'schoolName': instance.schoolName,
      'id': instance.id,
      'country': instance.country,
      'location': instance.location,
      'createdDate': instance.createdDate,
      'updatedDate': instance.updatedDate,
    };
