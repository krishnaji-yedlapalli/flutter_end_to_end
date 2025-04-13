
import 'package:sample_latest/features/daily_tracker/data/model/action_event.dart';


class EventEntity {
  final String id;
  final String eventType;
  final String title;
  final String description;
  final int createdDate;
  final int? updatedDate;
  final int selectedDateTime;
  final List<ActionEventModel> actionCheckList;
  final int? startDateTime;
  final int? endDateTime;
  final String status;

  EventEntity({
    required this.id,
    required this.eventType,
    required this.title,
    required this.description,
    required this.createdDate,
    required this.selectedDateTime,
    required this.actionCheckList,
    this.updatedDate,
    this.startDateTime,
    this.endDateTime,
    this.status = 'pending',
  });
}
