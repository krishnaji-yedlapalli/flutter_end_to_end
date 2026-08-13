import 'package:app_core/core/data/token/storage_write_failure.dart';
import 'package:app_core/core/data/token/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure token storage implementation backed by flutter_secure_storage.
class TokenStorageImpl implements TokenStorage {
  final FlutterSecureStorage _secureStorage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  TokenStorageImpl(this._secureStorage);

  @override
  Future<String?> readAccessToken() async {
    try {
      return await _secureStorage.read(key: _accessTokenKey);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> readRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> writeAccessToken(String token) async {
    try {
      await _secureStorage.write(key: _accessTokenKey, value: token);
    } catch (e) {
      throw StorageWriteFailure(
        operation: 'write',
        key: _accessTokenKey,
        cause: e,
      );
    }
  }

  @override
  Future<void> writeRefreshToken(String token) async {
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: token);
    } catch (e) {
      throw StorageWriteFailure(
        operation: 'write',
        key: _refreshTokenKey,
        cause: e,
      );
    }
  }

  @override
  Future<void> deleteAccessToken() async {
    try {
      await _secureStorage.delete(key: _accessTokenKey);
    } catch (e) {
      throw StorageWriteFailure(
        operation: 'delete',
        key: _accessTokenKey,
        cause: e,
      );
    }
  }

  @override
  Future<void> deleteRefreshToken() async {
    try {
      await _secureStorage.delete(key: _refreshTokenKey);
    } catch (e) {
      throw StorageWriteFailure(
        operation: 'delete',
        key: _refreshTokenKey,
        cause: e,
      );
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
    } catch (e) {
      throw StorageWriteFailure(
        operation: 'delete',
        key: 'all',
        cause: e,
      );
    }
  }
}
