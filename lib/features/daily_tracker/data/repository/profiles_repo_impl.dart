
import 'package:sample_latest/features/daily_tracker/data/model/profile_dto.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/profile_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/repository/profiles_repository.dart';

import '../../../../core/data/base_service.dart';
import '../../../../core/data/urls.dart';
import '../../core/services/session_manager.dart';

class ProfilesRepositoryImpl implements ProfilesRepository{

  ProfilesRepositoryImpl(this.baseService, this._sessionManager);

  final BaseService baseService;
  final SessionManager _sessionManager;

  @override
  Future<List<ProfileEntity>> fetchExistingProfiles() async {
    var users = <ProfileEntity>[];

    var response = await baseService.makeRequest(url: '${Urls.profiles}/${_sessionManager.accountId}.json');
    if(response != null && response['profiles'] != null) {
      users = response['profiles'].map<ProfileEntity>((json) => ProfileDto.fromJson(json).toProfileEntity()).toList();
    }
    return users;
  }

}