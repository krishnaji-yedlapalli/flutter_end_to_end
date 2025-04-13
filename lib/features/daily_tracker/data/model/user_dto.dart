
import 'package:json_annotation/json_annotation.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/user_entity.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class ProfileDto {

  ProfileDto(this.id, this.name);

  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  final String name;

  ProfileEntity toProfileEntity() {
   return ProfileEntity(
      id,
      name
    );
  }

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}