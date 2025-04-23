import '../../shared/params/user_credentails.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserAuthEntity> validateTheUserLoginCredentials(
      UserCredentialsParams params);
}
