
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

class MockFirebase extends Mock implements FirebasePlatform {}

void setupFirebaseMockss() {

  TestWidgetsFlutterBinding.ensureInitialized();

  final mockFirebaseCore = MockFirebaseApp();

  setupFirebaseCoreMocks();


  when(mockFirebaseCore.initializeApp('name', PigeonFirebaseOptions(
    apiKey: '123',
    projectId: '123',
    appId: '123',
    messagingSenderId: '123',
  )).then((_) async => FirebaseApp));

  // FirebasePlatform.instance = mockFirebaseCore;

}