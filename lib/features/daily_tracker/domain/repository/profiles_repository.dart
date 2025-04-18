import '../entities/profile_entity.dart';

abstract class ProfilesRepository {
  Future<List<ProfileEntity>> fetchExistingProfiles();

  Future<ProfileEntity> createOrEditProfile(ProfileEntity profile);
}
