// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchoolDetailsModel _$SchoolDetailsModelFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'schoolName'],
  );
  return SchoolDetailsModel(
    json['id'] as String,
    json['schoolName'] as String,
    json['country'] as String,
    json['location'] as String,
    json['image'] as String,
    json['studentCount'] as int,
    json['employeeCount'] as int,
    json['hostelAvailability'] as bool,
    json['createdDate'] as int,
    updatedDate: json['updatedDate'] as int?,
  );
}

Map<String, dynamic> _$SchoolDetailsModelToJson(SchoolDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'schoolName': instance.schoolName,
      'country': instance.country,
      'location': instance.location,
      'image': instance.image,
      'studentCount': instance.studentCount,
      'employeeCount': instance.employeeCount,
      'hostelAvailability': instance.hostelAvailability,
      'createdDate': instance.createdDate,
      'updatedDate': instance.updatedDate,
    };
