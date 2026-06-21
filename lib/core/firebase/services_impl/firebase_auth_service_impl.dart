import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample_latest/core/firebase/services/firebase_auth_service.dart';

/// Concrete implementation of [FirebaseAuthService].
class FirebaseAuthServiceImpl extends FirebaseAuthService {
  FirebaseAuthServiceImpl();

  late final FirebaseAuth _auth;
  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    _auth = FirebaseAuth.instance;
    _isInitialized = true;
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }

  @override
  Future<AuthResult> signInWithEmailAndPassword(
      String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUserToAuthResult(credential.user!, isNewUser: false);
  }

  @override
  Future<AuthResult> createUserWithEmailAndPassword(
      String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUserToAuthResult(credential.user!, isNewUser: true);
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return _mapUserToAuthResult(
      userCredential.user!,
      isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
    );
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  String? get currentUserEmail => _auth.currentUser?.email;

  @override
  bool get isSignedIn => _auth.currentUser != null;

  @override
  Stream<AuthResult?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;
      return _mapUserToAuthResult(user, isNewUser: false);
    });
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  AuthResult _mapUserToAuthResult(User user, {required bool isNewUser}) {
    return AuthResult(
      userId: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isNewUser: isNewUser,
    );
  }
}
