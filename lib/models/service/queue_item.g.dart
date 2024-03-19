// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueueItem _$QueueItemFromJson(Map<String, dynamic> json) => QueueItem(
      json['path'] as String,
      json['methodType'] as String,
      body: json['body'],
      queryParams: json['queryParams'] as Map<String, dynamic>?,
      priority: json['priority'] as int? ?? -1,
      id: json['id'] as String?,
      queueId: json['queueId'] as int?,
    );

Map<String, dynamic> _$QueueItemToJson(QueueItem instance) => <String, dynamic>{
      'id': instance.id,
      'queueId': instance.queueId,
      'path': instance.path,
      'methodType': instance.methodType,
      'body': instance.body,
      'queryParams': instance.queryParams,
      'priority': instance.priority,
    };
