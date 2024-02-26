import 'package:json_annotation/json_annotation.dart';

part 'queue_item.g.dart';

@JsonSerializable()
class QueueItem {

  final int? id;

  final String path;

  final String methodType;

  final dynamic body;

  final Map<String ,dynamic>? queryParams;

  final int priority;

  QueueItem(this.path, this.methodType, {this.body, this.queryParams, this.priority = -1, this.id});

  factory QueueItem.fromJson(Map<String, dynamic> json) => _$QueueItemFromJson(json);

  Map<String, dynamic> toJson() => _$QueueItemToJson(this);

}