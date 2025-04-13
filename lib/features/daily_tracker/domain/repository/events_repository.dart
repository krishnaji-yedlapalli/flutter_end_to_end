
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';

abstract class EventsRepository {

  Future<List<EventEntity>> fetchEventsBasedOnProfile(String accountId, String id );
}
