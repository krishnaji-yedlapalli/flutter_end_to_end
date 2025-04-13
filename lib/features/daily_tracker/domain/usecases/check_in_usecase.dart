
import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/features/daily_tracker/domain/repository/check_in_status_repo.dart';

import '../../../../analytics_exception_handler/exception_handler.dart';
import '../../../../core/data/utils/service_enums_typedef.dart';

class PerformUserCheckInUseCase {

  PerformUserCheckInUseCase(this._checkInStatusRepository);

  final CheckInStatusRepository _checkInStatusRepository;

  Future<Either<ErrorDetails, bool>> call() async {
    try {
      var res = await _checkInStatusRepository.submitUserCheckIn(
          'u94jTpJvOXbBVmO7rLTPf8Ew2zx2');
      return const Right(true);
    }catch(e,s){
      return  Left(ExceptionHandler().handleException(e, s));
    }
  }
}