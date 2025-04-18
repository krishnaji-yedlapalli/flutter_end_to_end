import 'package:sample_latest/features/daily_tracker/domain/entities/user_entity.dart';

class SessionManager {
  late final String userId;
  late final String userEmail;
  late final String token;
  late final int expiresIn;

  void initialize(UserAuthEntity userDetails) {
    userId = userDetails.id;
    userEmail = userDetails.userEmail;
    token = userDetails.token;
    expiresIn = userDetails.expiresIn;
  }

  String get accountId => userId;

  void clear() {
  }
}
