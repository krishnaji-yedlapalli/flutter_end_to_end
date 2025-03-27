
import 'package:json_annotation/json_annotation.dart';

part 'action_event.g.dart';

@JsonSerializable()
class ActionEventModel {

  ActionEventModel(this.label, this.isSelected);

  @JsonKey(required: true)
  final String label;

  @JsonKey(required: true)
  bool isSelected = false;

  factory ActionEventModel.fromJson(Map<String, dynamic> json) =>
      _$ActionEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActionEventModelToJson(this);

}
