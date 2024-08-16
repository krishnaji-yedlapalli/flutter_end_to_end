part of 'daily_status_tracker_bloc.dart';

enum DailyStatusTrackerLoadedType {greeting, events, students, student, todayEvents}

abstract class DailyStatusTrackerState extends Equatable {

  final DailyStatusTrackerLoadedType dailyStatusTrackerLoadedType;

   const DailyStatusTrackerState(this.dailyStatusTrackerLoadedType);
}

class DailyStatusTrackerInitial extends DailyStatusTrackerState {

  const DailyStatusTrackerInitial(super.dailyStatusTrackerLoadedType);

  @override
  List<Object?> get props => [];
}

class DailyStatusTrackerLoading extends DailyStatusTrackerState {

  const DailyStatusTrackerLoading(super.dailyStatusTrackerLoadedType);

  @override
  List<Object?> get props => [];
}

class DailyStatusTrackerCheckInStatus extends DailyStatusTrackerState {

  final PartsOfDay timeOfDay;
  final bool isCheckedIn;
  final List<DailyTrackerEventModel> events;

  const DailyStatusTrackerCheckInStatus(this.events, this.timeOfDay, this.isCheckedIn, super.dailyStatusTrackerLoadedType);

  @override
  List<Object?> get props => [events, timeOfDay, isCheckedIn, dailyStatusTrackerLoadedType];
}

class DailyStatusTrackerEvents extends DailyStatusTrackerState {

  final List<DailyTrackerEventModel> events;

  const DailyStatusTrackerEvents(this.events, super.dailyStatusTrackerLoadedType);

  @override
  List<Object?> get props => [events, dailyStatusTrackerLoadedType];
}

