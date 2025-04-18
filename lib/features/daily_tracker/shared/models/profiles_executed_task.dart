import 'package:sample_latest/features/daily_tracker/domain/entities/profile_entity.dart';

class ProfilesExecutedTask {
  var _profiles = <ProfileEntity>[];

  set setProfiles(List<ProfileEntity> profiles) {
    if (profiles.isNotEmpty) {
      _profiles = profiles;
    }
  }

  set addProfile(ProfileEntity profile){
    _profiles.add(profile);
  }

  set updateProfile(ProfileEntity profile){
   var index = _profiles.indexWhere((p)=> p.id == profile.id);
    if(index != -1){
      _profiles[index] = profile;
    }
  }

  List<ProfileEntity> get profiles => _profiles;

  ProfileEntity getProfileBasedOnId(String id) =>
      _profiles.firstWhere((p) => p.id == id);

  deleteProfile(String id) => _profiles.removeWhere((p) => p.id == id);
}
