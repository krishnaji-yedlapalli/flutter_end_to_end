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
    json['id'] as String,
    json['schoolId'] as String,
    json['studentName'] as String,
    json['studentLocation'] as String,
    json['standard'] as String,
    json['createdDate'] as int,
    updatedDate: json['updatedDate'] as int?,
  );
}

Map<String, dynamic> _$StudentModelToJson(StudentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'schoolId': instance.schoolId,
      'studentName': instance.studentName,
      'studentLocation': instance.studentLocation,
      'standard': instance.standard,
      'createdDate': instance.createdDate,
      'updatedDate': instance.updatedDate,
    };
