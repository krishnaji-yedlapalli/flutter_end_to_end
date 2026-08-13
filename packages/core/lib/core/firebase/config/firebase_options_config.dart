import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Centralized Firebase options configuration per platform.
///
/// Update these values from your `google-services.json` / `GoogleService-Info.plist`
/// or via the FlutterFire CLI output.
class FirebaseOptionsConfig {
  const FirebaseOptionsConfig._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Firebase is not supported on Linux.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'Firebase is not supported on Windows.',
        );
      default:
        throw UnsupportedError(
          'FirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCtodL7DA8dz3B5HEMuJ7di0DY2MEQOjws',
    appId: '1:334267766183:web:a26cc63b3cc29fe3a35282',
    messagingSenderId: '334267766183',
    projectId: 'flutter-end-to-end',
    authDomain: 'flutter-end-to-end.firebaseapp.com',
    storageBucket: 'flutter-end-to-end.appspot.com',
    measurementId: 'G-NJEW95MV5Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYUkLiGg_EsknSReddn1ZVijODPdEwqGw',
    appId: '1:334267766183:android:986bb1f13deca8c4a35282',
    messagingSenderId: '334267766183',
    projectId: 'flutter-end-to-end',
    storageBucket: 'flutter-end-to-end.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBt0ks4rwqe2wAy3xrUszvQOY-s48yignA',
    appId: '1:334267766183:ios:d93d9771baaabea8a35282',
    messagingSenderId: '334267766183',
    projectId: 'flutter-end-to-end',
    storageBucket: 'flutter-end-to-end.appspot.com',
    iosBundleId: 'com.example.sampleLatest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBt0ks4rwqe2wAy3xrUszvQOY-s48yignA',
    appId: '1:334267766183:ios:a241a09460830bcda35282',
    messagingSenderId: '334267766183',
    projectId: 'flutter-end-to-end',
    storageBucket: 'flutter-end-to-end.appspot.com',
    iosBundleId: 'com.example.sampleLatest.RunnerTests',
  );
}
