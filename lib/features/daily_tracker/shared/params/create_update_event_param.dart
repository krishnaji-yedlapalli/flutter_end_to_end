import '../../domain/entities/event_entity.dart';

class CreateUpdateEventParams {
  final String profileId;
  final EventEntity event;

  CreateUpdateEventParams(this.profileId, this.event);
}
