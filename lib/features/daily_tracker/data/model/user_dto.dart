
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserDto {

  UserDto(this.id, this.name);

  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  final String name;

}