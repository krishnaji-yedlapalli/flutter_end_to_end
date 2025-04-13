import '../entities/user_entity.dart';

abstract class ProfilesRepository {
  Future<List<ProfileEntity>> fetchExistingProfiles(String accountId );
}
