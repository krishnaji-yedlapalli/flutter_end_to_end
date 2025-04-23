import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:sample_latest/features/daily_tracker/data/model/profile_dto.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/profile_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/repository/profiles_repository.dart';

import '../../../../core/data/base_service.dart';
import '../../../../core/data/urls.dart';
import '../../core/services/session_manager.dart';

class ProfilesRepositoryImpl implements ProfilesRepository {
  ProfilesRepositoryImpl(this.baseService, this._sessionManager);

  final BaseService baseService;
  final SessionManager _sessionManager;

  @override
  Future<List<ProfileEntity>> fetchExistingProfiles() async {
    var users = <ProfileEntity>[];

    await _sessionManager.getLoginStatus();
    var response = await baseService.makeRequest(
        url: '${Urls.profiles}/${_sessionManager.accountId}/profiles.json');
    if (response != null && response is Map && response.keys.isNotEmpty) {
      users = response.entries
          .map<ProfileEntity>(
              (json) => ProfileDto.fromJson(json.value).toProfileEntity())
          .toList();
    }
    return users;
  }

  @override
  Future<ProfileEntity> createOrEditProfile(ProfileEntity profile) async {
    var response = await baseService.makeRequest(
        url:
            '${Urls.profiles}/${_sessionManager.accountId}/profiles/${profile.id}.json',
        body: profile.toJson(),
        method: RequestType.patch);
    if (response != null) {
      profile = ProfileDto.fromJson(response).toProfileEntity();
    } else {
      throw Exception('No profile was created');
    }
    return profile;
  }
}
