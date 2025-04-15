import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/repository/events_repository.dart';

import '../../../../analytics_exception_handler/exception_handler.dart';
import '../../../../core/data/utils/service_enums_typedef.dart';
import '../../../../core/mixins/date_formats.dart';
import '../../../../core/mixins/helper_methods.dart';
import '../../../../core/utils/enums_type_def.dart';
import '../../shared/models/profile_executed_task.dart';

class EventsUseCase with HelperMethods, DateFormats {

  EventsUseCase(this._repository, this._profileExecutedTask);

  final EventsRepository _repository;

  final ProfileExecutedTask _profileExecutedTask;

  Future<Either<ErrorDetails, List<EventEntity>>> call() async {
    try {
      var events = await _repository.fetchEventsBasedOnProfile(
          _profileExecutedTask.accountId, _profileExecutedTask.profileId);

      var todayEvents = getTodayEvents(events);
      _profileExecutedTask.todayEvents = todayEvents;
      return Right(todayEvents);
    } catch (e, s) {
      return Left(ExceptionHandler().handleException(e, s));
    }
  }

  List<EventEntity> getTodayEvents(List<EventEntity> events) {
    var todayEvents = <EventEntity>[];

    try {
      if (events.isNotEmpty) {
        for (var event in events) {
          EventDayType eventType = HelperMethods.enumFromString(
                  EventDayType.values, event.eventType) ??
              EventDayType.everyday;
          var selectedDateTime =
              DateTime.fromMillisecondsSinceEpoch(event.selectedDateTime);

          switch (eventType) {
            case EventDayType.everyday:
              todayEvents.add(event);
            case EventDayType.dayByDay:
              var days = daysBetweenTwoDates(selectedDateTime, DateTime.now());
              if (days.isEven) {
                todayEvents.add(event);
              }
            case EventDayType.weekly:
              if (selectedDateTime.weekday == DateTime.now().weekday) {
                todayEvents.add(event);
              }
            case EventDayType.fortnight:
            case EventDayType.quaterly:
            case EventDayType.customDate:
              if (compareDatesWithoutTime(selectedDateTime, DateTime.now())) {
                todayEvents.add(event);
              }
            case EventDayType.action:
              todayEvents.add(event);
          }
        }
      }
    } catch (e, s) {}

    todayEvents.sort((a, b) => EventStatus.values
        .indexWhere((e) => a.status == e.name)
        .compareTo(EventStatus.values.indexWhere((e) => a.status == e.name)));

    return todayEvents;
  }
}
