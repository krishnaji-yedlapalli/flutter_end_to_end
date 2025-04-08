
part of 'check_in_status_bloc.dart';

abstract class DailyCheckInStatus {
  const DailyCheckInStatus();
}

class DailyCheckInStatusInitial extends DailyCheckInStatus {
  const DailyCheckInStatusInitial();
}

class DailyCheckInStatusLoaded extends DailyCheckInStatus {

  final CheckInStatusEntity checkInStatusEntity;

  DailyCheckInStatusLoaded(this.checkInStatusEntity);
}

class DailyCheckInStatusFailed extends DailyCheckInStatus {
  const DailyCheckInStatusFailed();
}
