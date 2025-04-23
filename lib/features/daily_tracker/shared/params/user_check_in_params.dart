import '../../domain/entities/event_entity.dart';

class UserCheckInParams {
  final String profileId;
  final List<EventEntity> events;
  final String date;

  UserCheckInParams(this.profileId, this.events, this.date);
}
