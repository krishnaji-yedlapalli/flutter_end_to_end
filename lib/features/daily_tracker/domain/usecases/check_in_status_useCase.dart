import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:sample_latest/features/daily_tracker/shared/models/profile_executed_task.dart';

import '../../../../analytics_exception_handler/exception_handler.dart';
import '../../shared/params/user_check_in_params.dart';
import '../entities/checkIn_status_entity.dart';
import '../repository/check_in_status_repo.dart';

class CheckInStatusUseCase {
  CheckInStatusUseCase(this.checkInStatusRepository, this.profileExecutedTask);

  final CheckInStatusRepository checkInStatusRepository;

  final ProfileExecutedTask profileExecutedTask;

  Future<Either<ErrorDetails, CheckInStatusEntity>> call(String date) async {
    try {
      var params = UserCheckInParams(profileExecutedTask.profileId, [], date);
      var checkInDetails = await checkInStatusRepository.isCheckedIn(params);
      profileExecutedTask.todayEvents = checkInDetails.events;
      return Right(checkInDetails);
    } catch (e, s) {
      return Left(ExceptionHandler().handleException(e, s));
    }
  }
}
