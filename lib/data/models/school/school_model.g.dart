// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchoolModel _$SchoolModelFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['schoolName'],
  );
  return SchoolModel(
    json['schoolName'] as String,
    json['country'] as String,
    json['location'] as String,
    json['schoolId'] as int,
  );
}

Map<String, dynamic> _$SchoolModelToJson(SchoolModel instance) =>
    <String, dynamic>{
      'schoolName': instance.schoolName,
      'country': instance.country,
      'location': instance.location,
      'schoolId': instance.schoolId,
    };
