
import 'package:sample_latest/features/daily_tracker/domain/repository/users_repository.dart';

import '../entities/user_entity.dart';

class UsersUseCase {

  UsersUseCase(this._repository);

  final UsersRepository _repository;

  Future<List<UserEntity>> call() async {
    return await _repository.fetchExistingUsers();
  }
}