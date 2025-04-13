// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDto _$UserDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'name'],
  );
  return ProfileDto(
    json['id'] as String,
    json['name'] as String,
  );
}

Map<String, dynamic> _$UserDtoToJson(ProfileDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
