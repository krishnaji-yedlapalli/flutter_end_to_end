import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/user_entity.dart';

class SessionManager {
  late final String userId;
  late final String userEmail;
  late final String token;
  late final int expiresIn;

  final _storage = const FlutterSecureStorage();

  void initialize(UserAuthEntity userDetails) {
    userId = userDetails.id;
    userEmail = userDetails.userEmail;
    token = userDetails.token;
    expiresIn = userDetails.expiresIn;

    storeLoginDetails(userDetails);
  }

  Future<bool> getLoginStatus() async {
    var status = false;
    try {
      status = await _storage.containsKey(key: 'loginDetails');
      if (status) {
        var loginDetails =
            jsonDecode((await _storage.read(key: 'loginDetails'))!);
        initialize(UserAuthEntity.fromJson(loginDetails));
      }
    } catch (e, s) {}
    return status;
  }

  Future<void> storeLoginDetails(UserAuthEntity userDetails) async {
    try {
      _storage.write(
          key: 'loginDetails', value: jsonEncode(userDetails.toJson()));
    } catch (e, s) {}
  }

  String get accountId => userId;

  void clear() {}
}
