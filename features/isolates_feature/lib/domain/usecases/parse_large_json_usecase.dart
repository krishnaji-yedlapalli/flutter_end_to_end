import 'dart:convert';
import 'package:isolates_feature/data/models/user_model.dart';
import 'package:isolates_feature/domain/entities/user.dart';
import 'package:isolates_feature/domain/repositories/i_data_repository.dart';

class ParseLargeJsonUseCase {
  final IDataRepository repository;

  ParseLargeJsonUseCase(this.repository);

  /// Fetch and parse large JSON data
  Future<List<User>> execute(int recordCount) async {
    final jsonString = await repository.fetchLargeJsonString(recordCount);
    return parseJsonInIsolate(jsonString);
  }

  /// This will be executed in isolate
  static List<User> parseJsonInIsolate(String jsonString) {
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final usersList = decoded['users'] as List;

    return usersList
        .map((json) =>
            UserModel.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
  }
}
