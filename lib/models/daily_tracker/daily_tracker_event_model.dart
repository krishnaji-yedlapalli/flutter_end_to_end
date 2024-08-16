
import 'package:json_annotation/json_annotation.dart';

part 'daily_tracker_event_model.g.dart';

@JsonSerializable()
class DailyTrackerEventModel {

  DailyTrackerEventModel(this.id, this.eventType, this.title, this.description, this.createdDate, this.selectedDateTime, {this.updatedDate});

  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  final String eventType;

  final String title;

  final String description;

  final int createdDate;

  final int? updatedDate;

  final int selectedDateTime;

  factory DailyTrackerEventModel.fromJson(Map<String, dynamic> json) =>
      _$DailyTrackerEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyTrackerEventModelToJson(this);

}
