
import 'package:json_annotation/json_annotation.dart';
import 'package:sample_latest/features/daily_tracker/data/model/action_event.dart';
import 'package:sample_latest/utils/enums_type_def.dart';

part 'daily_tracker_event_model.g.dart';

@JsonSerializable()
class DailyTrackerEventModel {

  DailyTrackerEventModel(this.id, this.eventType, this.title, this.description, this.createdDate, this.selectedDateTime, this.actionCheckList, {this.updatedDate, this.startDateTime, this.endDateTime});

  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  final String eventType;

  final String title;

  final String description;

  final int createdDate;

  final int? updatedDate;

  final int selectedDateTime;

  final List<ActionEventModel> actionCheckList;

   int? startDateTime;

   int? endDateTime;

  String status = EventStatus.pending.name;

  factory DailyTrackerEventModel.fromJson(Map<String, dynamic> json) =>
      _$DailyTrackerEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyTrackerEventModelToJson(this);

}
