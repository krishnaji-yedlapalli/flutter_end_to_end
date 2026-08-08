/// Abstract interface for secure JWT token persistence.
abstract class TokenStorage {
  Future<String?> readAccessToken();
  Future<String?> readRefreshToken();
  Future<void> writeAccessToken(String token);
  Future<void> writeRefreshToken(String token);
  Future<void> deleteAccessToken();
  Future<void> deleteRefreshToken();
  Future<void> deleteAll();
}
