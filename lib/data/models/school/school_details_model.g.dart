// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchoolDetailsModel _$SchoolDetailsModelFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['schoolName'],
  );
  return SchoolDetailsModel(
    json['schoolId'] as int,
    json['schoolName'] as String,
    json['country'] as String,
    json['location'] as String,
    json['image'] as String,
    json['studentCount'] as int,
    json['employeeCount'] as int,
    json['hostelAvailability'] as bool,
  );
}

Map<String, dynamic> _$SchoolDetailsModelToJson(SchoolDetailsModel instance) =>
    <String, dynamic>{
      'schoolId': instance.schoolId,
      'schoolName': instance.schoolName,
      'country': instance.country,
      'location': instance.location,
      'image': instance.image,
      'studentCount': instance.studentCount,
      'employeeCount': instance.employeeCount,
      'hostelAvailability': instance.hostelAvailability,
    };
