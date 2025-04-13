
import '../../data/model/daily_tracker_event_model.dart';
import '../entities/checkIn_status_entity.dart';

abstract class CheckInStatusRepository {

  Future<CheckInStatusEntity> isCheckedIn(String date);

  Future<CheckInStatusEntity> submitUserCheckIn(String date);
}