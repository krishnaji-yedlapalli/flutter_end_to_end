
import 'package:json_annotation/json_annotation.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/profile_entity.dart';

part 'profile_dto.g.dart';

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
      _$ProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);
}