import '../../shared/params/user_check_in_params.dart';
import '../entities/checkIn_status_entity.dart';

abstract class CheckInStatusRepository {
  Future<CheckInStatusEntity> isCheckedIn(UserCheckInParams params);

  Future<bool> submitUserCheckIn(UserCheckInParams params);
}
