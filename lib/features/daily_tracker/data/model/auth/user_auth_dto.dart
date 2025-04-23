import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/user_entity.dart';

part 'user_auth_dto.g.dart';

@JsonSerializable()
class UserAuthDTO {
  final String kind;
  final String localId;
  final String email;
  final String displayName;
  final String idToken;
  final bool registered;
  final String refreshToken;
  final String expiresIn;

  UserAuthDTO({
    required this.kind,
    required this.localId,
    required this.email,
    required this.displayName,
    required this.idToken,
    required this.registered,
    required this.refreshToken,
    required this.expiresIn,
  });

  UserAuthEntity toEntity() {
    return UserAuthEntity(
      localId,
      email,
      idToken,
      int.tryParse(expiresIn) ?? 0,
    );
  }


  factory UserAuthDTO.fromJson(Map<String, dynamic> json) => _$UserAuthDTOFromJson(json);
  Map<String, dynamic> toJson() => _$UserAuthDTOToJson(this);
}
