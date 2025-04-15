import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/usecases/events_usecase.dart';

import '../../../../domain/usecases/create_update_event_usecase.dart';
import '../../../greetings/presentation/cubit/check_in_status_cubit.dart';

part 'event_cubit_state.dart';

class EventsCubit extends Cubit<EventsState> {

  final CheckInStatusCubit _checkInStatusCubit;

  final EventsUseCase eventsUseCase;

  final CreateUpdateEventUseCase _createUpdateEventUseCase;

  EventsCubit(this._checkInStatusCubit, this.eventsUseCase, this._createUpdateEventUseCase)
      : super(EventsStateLoading());

  Future<void> loadEventsBasedOnTheUser() async {
    emit(EventsStateLoading());

    var res = await eventsUseCase.call();

    res.fold(
      (failure) {
        // Handle the left (error) case here
        // emit(CheckInStatusFailed(failure.message));
      },
      (events) {
        emit(EventsStateLoaded(events));
      },
    );
  }

  void createOrUpdateEvent(EventEntity event) async {
    var res = await _createUpdateEventUseCase.call(event);
    res.fold((failure) {
      print(failure);
    }, (events) {
      _checkInStatusCubit.updateEvents(events);
      emit(EventsStateLoaded(events));
    });
  }

  Future<void> updateTodayEventDetails(EventEntity selectedEvent) async {
    //
    //   var index = todayEvents.indexWhere((event) => event.id == selectedEvent.id);
    //
    //   if(index != -1){
    //     todayEvents[index] = selectedEvent;
    //   }else{
    //     todayEvents.add(selectedEvent);
    //   }
    //
    //   var body = {
    //     currentDateInFormatted : {
    //       'isChecked' : true,
    //       'events' : todayEvents.map((e)=> e.toJson()).toList()
    //     }
    //   };
    //
    //   bool status = await repository.checkInTheUser(body);
  }

  Future<void> deleteEvent(EventEntity selectedEvent) async {
    //   bool status = await repository.deleteEvent(selectedEvent.id);
    //   events.removeWhere((event) => event.id == selectedEvent.id);
    //   var items = events.map((event)=> DailyTrackerEventModel.fromJson(event.toJson())).toList();
    //   emit(DailyStatusTrackerEvents(items, DailyStatusTrackerLoadedType.events));
  }
}
