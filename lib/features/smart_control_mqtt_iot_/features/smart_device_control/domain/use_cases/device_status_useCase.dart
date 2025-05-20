


import 'package:fpdart/fpdart.dart';

import '../../../../../../analytics_exception_handler/exception_handler.dart';
import '../../../../../../core/data/utils/service_enums_typedef.dart';
import '../repository/smart_device_control_repo.dart';

class SmartDeviceStatusUseCase {

final SmartDeviceControlRepository _repository;

SmartDeviceStatusUseCase(this._repository);

  Future<Either<bool, ErrorDetails>> call(String ip) async {
    try {
      var status = await _repository.getStatus(ip);
      return Left(status);
    }catch(e,s){
      return Right(ExceptionHandler().handleException(e, s));
    }
  }

// Future<bool> on() async {
//   return _repository.on();
// }
//
// Future<bool> off() async {
//   return _repository.off();
// }
}