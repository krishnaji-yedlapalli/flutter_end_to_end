class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() => _instance;

  SessionManager._internal();

  // User details
  String? userId;
  String? userName;
  String? token;
  int? expiresIn;

  // You can add convenience methods
  bool get isLoggedIn => token != null;

  void clear() {
    userId = null;
    userName = null;
    token = null;
    expiresIn = null;
  }
}
