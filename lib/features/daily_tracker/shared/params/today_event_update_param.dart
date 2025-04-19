

import '../../domain/entities/event_entity.dart';

class TodayEventParam {

  final  String profileId;
  final EventEntity event;
  final String date;

  TodayEventParam(this.profileId, this.event, this.date);
}