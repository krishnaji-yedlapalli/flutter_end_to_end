
import 'package:sample_latest/features/daily_tracker/data/model/action_event.dart';


class EventEntity {
  final String? id;
  final String eventType;
  final String title;
  final String description;
  final int createdDate;
  final int? updatedDate;
  final int selectedDateTime;
  final List<ActionEventModel> actionCheckList;
  int? startDateTime;
  int? endDateTime;
  String status;

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventType': eventType,
      'title': title,
      'description': description,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'selectedDateTime': selectedDateTime,
      'actionCheckList': actionCheckList.map((e) => e.toJson()).toList(),
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'status': status,
    };
  }

  factory EventEntity.fromJson(Map<String, dynamic> json) {
    return EventEntity(
      id: json['id'] as String?,
      eventType: json['eventType'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdDate: json['createdDate'] as int,
      updatedDate: json['updatedDate'] as int?,
      selectedDateTime: json['selectedDateTime'] as int,
      actionCheckList: (json['actionCheckList'] as List<dynamic>)
          .map((e) => ActionEventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      startDateTime: json['startDateTime'] as int?,
      endDateTime: json['endDateTime'] as int?,
      status: json['status'] as String? ?? 'pending',
    );
  }


  EventEntity copyWith({
    String? id,
    String? eventType,
    String? title,
    String? description,
    int? createdDate,
    int? updatedDate,
    int? selectedDateTime,
    List<ActionEventModel>? actionCheckList,
    int? startDateTime,
    int? endDateTime,
    String? status,
  }) {
    return EventEntity(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      title: title ?? this.title,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
      actionCheckList: actionCheckList ?? this.actionCheckList,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      status: status ?? this.status,
    );
  }

}
