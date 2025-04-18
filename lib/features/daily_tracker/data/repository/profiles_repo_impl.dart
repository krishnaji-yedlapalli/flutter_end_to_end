
import 'package:sample_latest/features/daily_tracker/data/model/user_dto.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/user_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/repository/profiles_repository.dart';

import '../../../../core/data/base_service.dart';
import '../../../../core/data/urls.dart';

class ProfilesRepositoryImpl implements ProfilesRepository{

  ProfilesRepositoryImpl(this.baseService);

  final BaseService baseService;

  @override
  Future<List<ProfileEntity>> fetchExistingProfiles(String accountId) async {
    var users = <ProfileEntity>[];

    var response = await baseService.makeRequest(url: '${Urls.profiles}/$accountId.json');
    if(response != null && response['profiles'] != null) {
      users = response['profiles'].map<ProfileEntity>((json) => ProfileDto.fromJson(json).toProfileEntity()).toList();
    }
    return users;
  }

}