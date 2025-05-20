import 'package:fpdart/fpdart.dart';

import '../../../../../../analytics_exception_handler/exception_handler.dart';
import '../../../../../../core/data/utils/service_enums_typedef.dart';
import '../repository/smart_device_control_repo.dart';

class SmartDeviceControlUseCase {
  final SmartDeviceControlRepository _repository;

  SmartDeviceControlUseCase(this._repository);

  Future<Either<bool, ErrorDetails>> call(String ip, bool isActive) async {
    try {
      var res = await (isActive ? _on(ip) : _off(ip));
      return Left(res);
    } catch (e, s) {
      return Right(ExceptionHandler().handleException(e, s));
    }
  }

  Future<bool> _on(String ip) async {
    return _repository.on(ip);
  }

  Future<bool> _off(String ip) async {
    return _repository.off(ip);
  }
}
