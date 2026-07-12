abstract class IDataRepository {
  Future<List<Map<String, dynamic>>> fetchLargeUserData(int count);
  Future<List<Map<String, dynamic>>> fetchLargeProductData(int count);
  Future<String> fetchLargeJsonString(int recordCount);
}
