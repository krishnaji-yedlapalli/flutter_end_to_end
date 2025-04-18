
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';

import '../../shared/params/create_update_event_param.dart';

abstract class EventsRepository {

  Future<List<EventEntity>> fetchEventsBasedOnProfile(String id );

  Future<bool> updateOrCreateEvent(CreateUpdateEventParams params);
}
