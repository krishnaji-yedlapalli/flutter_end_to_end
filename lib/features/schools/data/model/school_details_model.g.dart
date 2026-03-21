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
    (json['studentCount'] as num).toInt(),
    (json['employeeCount'] as num).toInt(),
    json['hostelAvailability'] as bool,
    (json['createdDate'] as num).toInt(),
    updatedDate: (json['updatedDate'] as num?)?.toInt(),
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
