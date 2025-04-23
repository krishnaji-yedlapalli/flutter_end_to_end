import 'event_entity.dart';

class CheckInStatusEntity {
  CheckInStatusEntity(
      {this.status = false, this.events = const <EventEntity>[]});

  final bool status;

  final List<EventEntity> events;
}
