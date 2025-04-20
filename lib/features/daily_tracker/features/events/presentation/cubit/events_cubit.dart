import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/usecases/delete_event_usecase.dart';
import 'package:sample_latest/features/daily_tracker/domain/usecases/events_usecase.dart';

import '../../../../../../core/mixins/date_formats.dart';
import '../../../../domain/usecases/create_update_event_usecase.dart';
import '../../../../domain/usecases/update_today_event_useCase.dart';
import '../../../greetings/presentation/cubit/check_in_status_cubit.dart';

part 'event_cubit_state.dart';

class EventsCubit extends Cubit<EventsState> with DateFormats{

  final CheckInStatusCubit _checkInStatusCubit;

  final EventsUseCase eventsUseCase;

  final CreateUpdateEventUseCase _createUpdateEventUseCase;

  final UpdateTodayEventUseCase _todayEventUseCase;

  final DeleteEventUseCase _deleteEventUseCase;

  EventsCubit(this._checkInStatusCubit, this.eventsUseCase, this._createUpdateEventUseCase, this._todayEventUseCase, this._deleteEventUseCase)
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
    }, (e) {
      _checkInStatusCubit.updateEvents(e.$1);
      _todayEventUseCase.call(currentDateInFormatted, e.$2);
      emit(EventsStateLoaded(e.$1));
    });
  }

  Future<void> updateTodayEventDetails(EventEntity selectedEvent) async {
    createOrUpdateEvent(selectedEvent);
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
   var res = await _deleteEventUseCase.call(selectedEvent.id!);
   res.fold((events){
     emit(EventsStateLoading());
     Future.delayed(const Duration(seconds: 1));
     emit(EventsStateLoaded(events));
   }, (error){

   });
  }
}
