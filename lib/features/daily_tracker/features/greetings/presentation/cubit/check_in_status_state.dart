part of 'check_in_status_cubit.dart';

sealed class CheckInStatusState extends Equatable {
  const CheckInStatusState();
}

class CheckInStatusLoading extends CheckInStatusState {
  const CheckInStatusLoading();

  @override
  List<Object?> get props => [];
}

class CheckInStatusWithChecked extends CheckInStatusState {
  final List<EventEntity> events;

  const CheckInStatusWithChecked(this.events);

  @override
  List<Object?> get props => [events];
}

class CheckInStatusNotYetChecked extends CheckInStatusState {
  final PartsOfDay timeOfDay;
  const CheckInStatusNotYetChecked(this.timeOfDay);

  @override
  List<Object?> get props => [];
}
