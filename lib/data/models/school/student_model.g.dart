// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentModel _$StudentModelFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id'],
  );
  return StudentModel(
    json['id'] as int,
    json['studentName'] as String,
    json['className'] as String,
    json['studentStrength'] as int,
    json['staffStrength'] as int,
    json['studentLocation'] as String,
    json['hostelAvailability'] as bool,
    json['standard'] as String,
  );
}

Map<String, dynamic> _$StudentModelToJson(StudentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentName': instance.studentName,
      'className': instance.className,
      'studentStrength': instance.studentStrength,
      'staffStrength': instance.staffStrength,
      'studentLocation': instance.studentLocation,
      'hostelAvailability': instance.hostelAvailability,
      'standard': instance.standard,
    };
