
import 'package:sample_latest/features/daily_tracker/data/model/user_dto.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/user_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/repository/users_repository.dart';

import '../../../../core/data/base_service.dart';
import '../../../../core/data/urls.dart';

class UserRepositoryImpl implements UsersRepository{

  UserRepositoryImpl(this.baseService);

  final BaseService baseService;

  @override
  Future<List<UserEntity>> fetchExistingUsers() async {
    var users = <UserEntity>[];

    var response = await baseService.makeRequest(url: '${Urls.dailyCheckIns}/.json');
    if(response != null && response['events'] != null) {
      users = response['events'].map<UserEntity>((json) => UserDto.fromJson(json)).toList();
    }
    return users;
  }

}