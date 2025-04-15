
import 'package:sample_latest/features/daily_tracker/domain/repository/profiles_repository.dart';

import '../../shared/models/profile_executed_task.dart';
import '../entities/user_entity.dart';

class ProfilesUseCase {

  ProfilesUseCase(this._repository, this._profileExecutedTask);

  final ProfilesRepository _repository;

  final ProfileExecutedTask _profileExecutedTask;

  Future<List<ProfileEntity>> call() async {
    return await _repository.fetchExistingProfiles(_profileExecutedTask.accountId);
  }
}