
import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';

import '../../../../analytics_exception_handler/exception_handler.dart';
import '../entities/checkIn_status_entity.dart';
import '../repository/check_in_status_repo.dart';

class CheckInStatusUseCase {

  CheckInStatusUseCase(this.checkInStatusRepository);

  final CheckInStatusRepository checkInStatusRepository;

  Future<Either<ErrorDetails, CheckInStatusEntity>> call(String date) async {
    try{
      var checkInDetails = await checkInStatusRepository.isCheckedIn(date);
     return Right(checkInDetails);
    }catch(e,s){
     return  Left(ExceptionHandler().handleException(e, s));
    }
  }
}