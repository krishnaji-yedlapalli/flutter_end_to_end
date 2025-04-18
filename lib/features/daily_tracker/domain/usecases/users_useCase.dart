
import 'package:sample_latest/features/daily_tracker/domain/repository/profiles_repository.dart';
import 'package:sample_latest/features/daily_tracker/shared/models/profiles_executed_task.dart';

import '../../shared/models/profile_executed_task.dart';
import '../entities/profile_entity.dart';

class ProfilesUseCase {

  ProfilesUseCase(this._repository, this._profilesExecutedTask);

  final ProfilesRepository _repository;

  final ProfilesExecutedTask _profilesExecutedTask;

  Future<List<ProfileEntity>> call() async {
    var profiles =  await _repository.fetchExistingProfiles();
    _profilesExecutedTask.setProfiles = profiles;
    return profiles;
  }
}