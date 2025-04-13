
import 'package:sample_latest/features/daily_tracker/domain/repository/profiles_repository.dart';

import '../entities/user_entity.dart';

class ProfilesUseCase {

  ProfilesUseCase(this._repository);

  final ProfilesRepository _repository;

  Future<List<ProfileEntity>> call() async {
    return await _repository.fetchExistingProfiles('u94jTpJvOXbBVmO7rLTPf8Ew2zx2');
  }
}