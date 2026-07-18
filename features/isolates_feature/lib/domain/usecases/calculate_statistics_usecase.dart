import 'package:isolates_feature/data/models/user_model.dart';
import 'package:isolates_feature/domain/repositories/i_data_repository.dart';

class DataStatistics {
  final int totalUsers;
  final double averageAge;
  final double averageSalary;
  final double minSalary;
  final double maxSalary;
  final Map<String, int> cityCounts;
  final Map<String, double> cityAverageSalaries;

  const DataStatistics({
    required this.totalUsers,
    required this.averageAge,
    required this.averageSalary,
    required this.minSalary,
    required this.maxSalary,
    required this.cityCounts,
    required this.cityAverageSalaries,
  });

  @override
  String toString() {
    return 'DataStatistics(total: $totalUsers, avgAge: ${averageAge.toStringAsFixed(1)}, avgSalary: \$${averageSalary.toStringAsFixed(0)})';
  }
}

class CalculateStatisticsUseCase {
  final IDataRepository repository;

  CalculateStatisticsUseCase(this.repository);

  /// Fetch and calculate statistics on large user data
  Future<DataStatistics> execute(int recordCount) async {
    final userData = await repository.fetchLargeUserData(recordCount);
    return calculateStatisticsInIsolate(userData);
  }

  /// This will be executed in isolate
  static DataStatistics calculateStatisticsInIsolate(
      List<Map<String, dynamic>> userData) {
    final users =
        userData.map((json) => UserModel.fromJson(json).toEntity()).toList();

    if (users.isEmpty) {
      return const DataStatistics(
        totalUsers: 0,
        averageAge: 0,
        averageSalary: 0,
        minSalary: 0,
        maxSalary: 0,
        cityCounts: {},
        cityAverageSalaries: {},
      );
    }

    // Basic statistics
    final totalUsers = users.length;
    final averageAge =
        users.map((u) => u.age).reduce((a, b) => a + b) / totalUsers;
    final averageSalary =
        users.map((u) => u.salary).reduce((a, b) => a + b) / totalUsers;
    final minSalary =
        users.map((u) => u.salary).reduce((a, b) => a < b ? a : b);
    final maxSalary =
        users.map((u) => u.salary).reduce((a, b) => a > b ? a : b);

    // City statistics
    final Map<String, int> cityCounts = {};
    final Map<String, List<double>> citySalaries = {};

    for (final user in users) {
      cityCounts[user.city] = (cityCounts[user.city] ?? 0) + 1;
      citySalaries.putIfAbsent(user.city, () => []).add(user.salary);
    }

    final Map<String, double> cityAverageSalaries = {};
    citySalaries.forEach((city, salaries) {
      cityAverageSalaries[city] =
          salaries.reduce((a, b) => a + b) / salaries.length;
    });

    return DataStatistics(
      totalUsers: totalUsers,
      averageAge: averageAge,
      averageSalary: averageSalary,
      minSalary: minSalary,
      maxSalary: maxSalary,
      cityCounts: cityCounts,
      cityAverageSalaries: cityAverageSalaries,
    );
  }
}
