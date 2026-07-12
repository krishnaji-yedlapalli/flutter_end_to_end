import 'package:isolates_feature/data/datasources/dummy_data_source.dart';
import 'package:isolates_feature/domain/repositories/i_data_repository.dart';

class DataRepositoryImpl implements IDataRepository {
  final DummyDataSource _dataSource;

  DataRepositoryImpl(this._dataSource);

  @override
  Future<List<Map<String, dynamic>>> fetchLargeUserData(int count) async {
    return await _dataSource.generateUsers(count);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchLargeProductData(int count) async {
    return await _dataSource.generateProducts(count);
  }

  @override
  Future<String> fetchLargeJsonString(int recordCount) async {
    return await _dataSource.generateLargeJsonString(recordCount);
  }
}
