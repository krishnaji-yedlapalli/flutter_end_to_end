
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/mixins/date_formats.dart';
import 'package:sample_latest/mixins/helper_methods.dart';
import 'package:sample_latest/models/daily_tracker/daily_tracker_event_model.dart';
import 'package:sample_latest/services/repository/daily_tracker_repository.dart';
import 'package:sample_latest/utils/enums_type_def.dart';

part 'daily_status_tracker_state.dart';

class DailyTrackerStatusBloc extends Cubit<DailyStatusTrackerState> with HelperMethods, DateFormats{

  final DailyTrackerRepository repository;
 var events  = <DailyTrackerEventModel>[];
 var todayEvents  = <DailyTrackerEventModel>[];

  DailyTrackerStatusBloc(this.repository)
      : super(const DailyStatusTrackerInitial(DailyStatusTrackerLoadedType.greeting));


  void getCheckInStatus() async {
    try{

      todayEvents.clear();

      if(events.isEmpty){
        getTodayEvents();
      }

      var status = await repository.isCheckedIn(currentDateInFormatted);
      emit(DailyStatusTrackerCheckInStatus(status.$2, getTimeOfDay(), status.$1, DailyStatusTrackerLoadedType.greeting));
    }catch(e,s){

    }
  }

  Future<void> checkIn({bool ignoreEmit = false}) async {
    try{

       todayEvents = await getTodayEvents();

      var body = {
        currentDateInFormatted : {
          'isChecked' : true,
          'events' : todayEvents.map((e)=> e.toJson()).toList()
        }
      };

     if(ignoreEmit) emit(DailyStatusTrackerCheckInStatus(todayEvents, getTimeOfDay(), true, DailyStatusTrackerLoadedType.greeting));
      bool status = await repository.checkInTheUser(body);
    }catch(e,s){

    }
  }

  void createOrUpdateEvent(DailyTrackerEventModel event, bool isCreate) async {
    try{

      if(isCreate){
        events.add(event);
      }else{
        var index = events.indexWhere((existingEvent) => existingEvent.id == event.id);
        if(index != -1){
          events[index] = event;
        }
      }

      await checkIn(ignoreEmit: true);
      var items = <DailyTrackerEventModel>[];
      for(var item in todayEvents){
        items.add(DailyTrackerEventModel.fromJson(item.toJson()));
      }
      emit(DailyStatusTrackerCheckInStatus(items, getTimeOfDay(), true, DailyStatusTrackerLoadedType.greeting));

      var createdEvent = await repository.createOrEditEvent(event);
      // emit(DailyStatusTrackerCheckInStatus(getTimeOfDay(), createdEvent, DailyStatusTrackerLoadedType.greeting));
    }catch(e,s){

    }
  }

  Future<void> fetchExistingEvents() async {
    try {
       events = await repository.fetchEventList();
      emit(DailyStatusTrackerEvents(
          events, DailyStatusTrackerLoadedType.events));
    } catch (e, s) {
     print(e.toString());
    }
  }

  Future<void> updateTodayEventDetails(DailyTrackerEventModel selectedEvent) async {

    var index = todayEvents.indexWhere((event) => event.id == selectedEvent.id);

    todayEvents[index] = selectedEvent;

    var body = {
      currentDateInFormatted : {
        'isChecked' : true,
        'events' : todayEvents.map((e)=> e.toJson()).toList()
      }
    };

    bool status = await repository.checkInTheUser(body);
  }



  Future<List<DailyTrackerEventModel>> getTodayEvents() async {
    try{

      todayEvents.clear();

      if(events.isEmpty){
        await fetchExistingEvents();
      }

      if(events.isNotEmpty){
        for(var event in events){
          EventDayType eventType = HelperMethods.enumFromString(EventDayType.values, event.eventType) ?? EventDayType.everyday;
          var selectedDateTime = DateTime.fromMillisecondsSinceEpoch(event.selectedDateTime);

          switch(eventType){
            case EventDayType.everyday:
              todayEvents.add(event);
            case EventDayType.dayByDay:
             var days = daysBetweenTwoDates(selectedDateTime, DateTime.now());
             if(days.isEven){
               todayEvents.add(event);
             }
            case EventDayType.weekly:
             if(selectedDateTime.weekday == DateTime.now().weekday){
               todayEvents.add(event);
             }
            case EventDayType.fortnight:

            case EventDayType.quaterly:

            case EventDayType.customDate:
            if(compareDatesWithoutTime(selectedDateTime, DateTime.now())){
              todayEvents.add(event);
            }
          }
        }
      }
    }catch(e,s){

    }

    todayEvents.sort((a, b) => a.selectedDateTime.compareTo(b.selectedDateTime));

    return todayEvents;
  }
}