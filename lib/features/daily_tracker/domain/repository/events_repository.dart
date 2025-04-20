

import '../../shared/params/create_update_event_param.dart';
import '../../shared/params/today_event_update_param.dart';
import '../entities/event_entity.dart';

abstract class EventsRepository {

  Future<List<EventEntity>> fetchEventsBasedOnProfile(String id );

  Future<bool> updateOrCreateEvent(CreateUpdateEventParams params);

  Future<bool> updateTodayEvents(TodayEventParam params);

  Future<bool> deleteEvent(String profileId, String eventId);

}
