
import 'package:fpdart/fpdart.dart';

import '../../../../analytics_exception_handler/exception_handler.dart';
import '../../../../core/data/utils/service_enums_typedef.dart';
import '../../shared/params/user_credentails.dart';
import '../repository/AuthRepository.dart';

class AuthUseCase {

  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  Future<Either<bool, ErrorDetails>> call(String email, String pwd) async {
    try {
      var params = UserCredentialsParams(
        email,
        pwd
      );
      var res = await _authRepository.validateTheUserLoginCredentials(params);
      return const Left(true);
    }catch(e,s){
      return Right(ExceptionHandler().handleException(e, s));
    }
  }

}