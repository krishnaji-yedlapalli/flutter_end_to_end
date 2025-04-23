import '../../../../core/mixins/date_formats.dart';
import '../../../../core/mixins/helper_methods.dart';
import '../../../../core/utils/enums_type_def.dart';
import '../../domain/entities/event_entity.dart';

class EventSortHelper with HelperMethods, DateFormats {
  List<EventEntity> getTodaySortedEvent(List<EventEntity> events) {
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
    } catch (e) {}

    todayEvents.sort((a, b) => EventStatus.values
        .indexWhere((e) => a.status == e.name)
        .compareTo(EventStatus.values.indexWhere((e) => a.status == e.name)));

    return todayEvents;
  }
}
