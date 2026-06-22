import 'package:sample_latest/core/firebase/services/firebase_service.dart';

/// Abstract contract for Firebase Authentication.
///
/// Provides authentication operations independent of Firebase SDK.
abstract class FirebaseAuthService extends FirebaseService {
  /// Signs in with email and password.
  Future<AuthResult> signInWithEmailAndPassword(String email, String password);

  /// Creates a new user with email and password.
  Future<AuthResult> createUserWithEmailAndPassword(
      String email, String password);

  /// Signs in with Google.
  Future<AuthResult> signInWithGoogle();

  /// Signs out the current user.
  Future<void> signOut();

  /// Gets the current authenticated user ID.
  String? get currentUserId;

  /// Gets the current user's email.
  String? get currentUserEmail;

  /// Whether a user is currently signed in.
  bool get isSignedIn;

  /// Stream of authentication state changes.
  Stream<AuthResult?> get authStateChanges;

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail(String email);
}

/// Lightweight auth result model to decouple from Firebase's User class.
class AuthResult {
  const AuthResult({
    required this.userId,
    this.email,
    this.displayName,
    this.photoUrl,
    this.isNewUser = false,
  });

  final String userId;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isNewUser;
}
