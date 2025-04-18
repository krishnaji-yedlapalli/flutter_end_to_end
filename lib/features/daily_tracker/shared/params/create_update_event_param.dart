


import '../../domain/entities/event_entity.dart';

class CreateUpdateEventParams {

  final  String profileId;
  final List<EventEntity> events;

  CreateUpdateEventParams(this.profileId, this.events);
}