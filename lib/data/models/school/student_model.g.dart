// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentModel _$StudentModelFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['studentName'],
  );
  return StudentModel(
    json['studentName'] as String,
    json['className'] as String,
    json['location'] as String,
    json['id'] as int,
  );
}

Map<String, dynamic> _$StudentModelToJson(StudentModel instance) =>
    <String, dynamic>{
      'studentName': instance.studentName,
      'className': instance.className,
      'location': instance.location,
      'id': instance.id,
    };
