import 'package:isolates_feature/data/models/user_model.dart';
import 'package:isolates_feature/domain/entities/user.dart';
import 'package:isolates_feature/domain/repositories/i_data_repository.dart';

enum SortType { name, age, salary, city }

class SortDataUseCase {
  final IDataRepository repository;

  SortDataUseCase(this.repository);

  /// Fetch and sort large user data
  Future<List<User>> execute(int recordCount, SortType sortType) async {
    final userData = await repository.fetchLargeUserData(recordCount);
    return sortUsersInIsolate(userData, sortType);
  }

  /// This will be executed in isolate
  static List<User> sortUsersInIsolate(
      List<Map<String, dynamic>> userData, SortType sortType) {
    final users =
        userData.map((json) => UserModel.fromJson(json).toEntity()).toList();

    switch (sortType) {
      case SortType.name:
        users.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.age:
        users.sort((a, b) => a.age.compareTo(b.age));
        break;
      case SortType.salary:
        users.sort((a, b) => a.salary.compareTo(b.salary));
        break;
      case SortType.city:
        users.sort((a, b) => a.city.compareTo(b.city));
        break;
    }

    return users;
  }
}
