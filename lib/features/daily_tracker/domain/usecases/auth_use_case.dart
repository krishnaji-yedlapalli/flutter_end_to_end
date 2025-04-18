
import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/features/daily_tracker/core/services/session_manager.dart';

import '../../../../analytics_exception_handler/exception_handler.dart';
import '../../../../core/data/utils/service_enums_typedef.dart';
import '../../shared/params/user_credentails.dart';
import '../repository/AuthRepository.dart';

class AuthUseCase {

  final AuthRepository _authRepository;
  final SessionManager _sessionManager;

  AuthUseCase(this._authRepository, this._sessionManager);

  Future<Either<bool, ErrorDetails>> call(String email, String pwd) async {
    try {
      var params = UserCredentialsParams(
        email,
        pwd
      );
      var res = await _authRepository.validateTheUserLoginCredentials(params);
      _sessionManager.initialize(res);
      return const Left(true);
    }catch(e,s){
      return Right(ExceptionHandler().handleException(e, s));
    }
  }

}