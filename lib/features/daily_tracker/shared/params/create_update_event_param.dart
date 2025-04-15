


import '../../domain/entities/event_entity.dart';

class CreateUpdateEventParams {

  final String accountId;
  final  String profileId;
  final List<EventEntity> events;

  CreateUpdateEventParams(this.accountId, this.profileId, this.events);
}