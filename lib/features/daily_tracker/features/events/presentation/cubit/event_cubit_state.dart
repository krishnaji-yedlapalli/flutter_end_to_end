part of 'events_cubit.dart';

sealed class EventsState extends Equatable {
  const EventsState();
}

class EventsStateLoading extends EventsState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EventsStateLoaded extends EventsState {
  final List<EventEntity> events;

  const EventsStateLoaded(this.events);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
