// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionEventModel _$ActionEventModelFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['label', 'isSelected'],
  );
  return ActionEventModel(
    json['label'] as String,
    json['isSelected'] as bool,
  );
}

Map<String, dynamic> _$ActionEventModelToJson(ActionEventModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'isSelected': instance.isSelected,
    };
