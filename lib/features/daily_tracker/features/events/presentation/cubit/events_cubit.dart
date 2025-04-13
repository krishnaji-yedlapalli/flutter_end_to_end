import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/usecases/events_usecase.dart';

import '../../../users/presentation/cubit/profiles_cubit.dart';

part 'event_cubit_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final ProfilesCubit profilesCubit;

  final EventsUseCase eventsUseCase;

  EventsCubit(this.profilesCubit, this.eventsUseCase)
      : super(EventsStateLoading());

 Future<void> loadEventsBasedOnTheUser() async {
    emit(EventsStateLoading());

    var res = await eventsUseCase.call('0');

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
}
