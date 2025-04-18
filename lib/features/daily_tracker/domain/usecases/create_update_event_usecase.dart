
import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';

import '../../../../analytics_exception_handler/exception_handler.dart';
import '../../../../core/data/utils/service_enums_typedef.dart';
import '../../../../core/mixins/helper_methods.dart';
import '../../data/model/daily_tracker_event_model.dart';
import '../../shared/models/profile_executed_task.dart';
import '../../shared/params/create_update_event_param.dart';
import '../repository/events_repository.dart';

class CreateUpdateEventUseCase {

  CreateUpdateEventUseCase(this._eventsRepository, this.profileExecutedTask);

  final EventsRepository _eventsRepository;

  final ProfileExecutedTask profileExecutedTask;

  Future<Either<ErrorDetails, List<EventEntity>>> call(EventEntity event) async {

    try {
      if (event.id == null) {
        event = createEvent(event);
      } else {
        event = updateEvent(event);
      }

      var res = await _eventsRepository.updateOrCreateEvent(CreateUpdateEventParams(profileExecutedTask.profileId, profileExecutedTask.todayEvents));
      return Right(profileExecutedTask.todayEvents);
    }catch(e,s){
      return  Left(ExceptionHandler().handleException(e, s));
    }
  }

  EventEntity createEvent(EventEntity event) {
   event = event.copyWith(id : HelperMethods.uuid);
   profileExecutedTask.todayEvents.add(event);
    profileExecutedTask.todayEvents = List.from(profileExecutedTask.todayEvents);
    return event;
  }

  EventEntity updateEvent(EventEntity event){

    var index = profileExecutedTask.todayEvents.indexWhere((existingEvent) => existingEvent.id == event.id);
    if(index != -1){
      profileExecutedTask.todayEvents[index] = event;
    }

    return event;
  }

}