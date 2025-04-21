import 'package:fpdart/fpdart.dart';

import '../../../../analytics_exception_handler/exception_handler.dart';
import '../../../../core/data/utils/service_enums_typedef.dart';
import '../../../../core/mixins/helper_methods.dart';
import '../../data/model/daily_tracker_event_model.dart';
import '../../shared/models/profile_executed_task.dart';
import '../../shared/params/create_update_event_param.dart';
import '../../shared/utils/event_sorter_converter.dart';
import '../entities/event_entity.dart';
import '../repository/events_repository.dart';

class CreateUpdateEventUseCase {
  CreateUpdateEventUseCase(this._eventsRepository, this.profileExecutedTask);

  final EventsRepository _eventsRepository;

  final ProfileExecutedTask profileExecutedTask;

  Future<
      Either<
          ErrorDetails,
          ({
            List<EventEntity> userEvents,
            List<EventEntity> todayEvents,
            EventEntity updatedEvent
          })>> call(EventEntity event) async {
    try {
      if (event.id == null) {
        event = createEvent(event);
      } else {
        event = updateEvent(event);
      }

      var res = await _eventsRepository.updateOrCreateEvent(
          CreateUpdateEventParams(profileExecutedTask.profileId, event));
      return Right((
        userEvents: profileExecutedTask.userEvents,
        todayEvents: EventSortHelper().getTodaySortedEvent(profileExecutedTask.todayEvents),
        updatedEvent: event
      ));
    } catch (e, s) {
      return Left(ExceptionHandler().handleException(e, s));
    }
  }

  EventEntity createEvent(EventEntity event) {
    event = event.copyWith(id: HelperMethods.uuid);
    profileExecutedTask.userEvents.add(event);
    profileExecutedTask.todayEvents.add(event);
    profileExecutedTask.userEvents = List.from(profileExecutedTask.userEvents);
    return event;
  }

  EventEntity updateEvent(EventEntity event) {
    var index = profileExecutedTask.userEvents
        .indexWhere((existingEvent) => existingEvent.id == event.id);
    if (index != -1) {
      profileExecutedTask.userEvents[index] = event;
    }

    return event;
  }
}
