// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAuthDTO _$UserAuthDTOFromJson(Map<String, dynamic> json) => UserAuthDTO(
      kind: json['kind'] as String,
      localId: json['localId'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      idToken: json['idToken'] as String,
      registered: json['registered'] as bool,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as String,
    );

Map<String, dynamic> _$UserAuthDTOToJson(UserAuthDTO instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'localId': instance.localId,
      'email': instance.email,
      'displayName': instance.displayName,
      'idToken': instance.idToken,
      'registered': instance.registered,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };
