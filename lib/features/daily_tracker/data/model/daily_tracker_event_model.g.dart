// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_tracker_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyTrackerEventModel _$DailyTrackerEventModelFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'eventType'],
  );
  return DailyTrackerEventModel(
    json['id'] as String,
    json['eventType'] as String,
    json['title'] as String,
    json['description'] as String,
    json['createdDate'] as int,
    json['selectedDateTime'] as int,
    (json['actionCheckList'] as List<dynamic>)
        .map((e) => ActionEventModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    updatedDate: json['updatedDate'] as int?,
    startDateTime: json['startDateTime'] as int?,
    endDateTime: json['endDateTime'] as int?,
  )..status = json['status'] as String;
}

Map<String, dynamic> _$DailyTrackerEventModelToJson(
        DailyTrackerEventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventType': instance.eventType,
      'title': instance.title,
      'description': instance.description,
      'createdDate': instance.createdDate,
      'updatedDate': instance.updatedDate,
      'selectedDateTime': instance.selectedDateTime,
      'actionCheckList': instance.actionCheckList.map((action) => action.toJson()).toList(),
      'startDateTime': instance.startDateTime,
      'endDateTime': instance.endDateTime,
      'status': instance.status,
    };
