import 'package:sample_latest/features/daily_tracker/domain/entities/user_entity.dart';
import 'package:sample_latest/features/daily_tracker/shared/params/user_credentails.dart';

import '../../../../core/data/base_service.dart';
import '../../../../core/data/utils/service_enums_typedef.dart';
import '../../domain/repository/AuthRepository.dart';
import '../model/auth/user_auth_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BaseService baseService;

  AuthRepositoryImpl(this.baseService);

  @override
  Future<UserAuthEntity> validateTheUserLoginCredentials(
      UserCredentialsParams params) async {
    UserAuthEntity? userEntity;

    var body = {
      "email": params.userEmail,
      "password": params.password,
      "returnSecureToken": true
    };

    var response = await baseService.makeRequest(
        baseUrl:
            'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword',
        url: '',
        body: body,
        queryParameters: {'key': 'AIzaSyAYUkLiGg_EsknSReddn1ZVijODPdEwqGw'},
        method: RequestType.post);
    if (response != null) {
      userEntity = UserAuthDTO.fromJson(response).toEntity();
    } else {
      throw UnimplementedError();
    }
    return userEntity;
  }
}
