
import '../../data/model/daily_tracker_event_model.dart';

abstract class CheckInStatusRepository {

  Future<(bool, List<DailyTrackerEventModel>)> isCheckedIn(String date);

}