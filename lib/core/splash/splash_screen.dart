import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _assetPath {
    if (kIsWeb) return 'asset/splash_screens/splash_web.png';
    if (Platform.isAndroid) return 'asset/splash_screens/splash_android.png';
    if (Platform.isIOS) return 'asset/splash_screens/splash_ios.png';
    if (Platform.isMacOS) return 'asset/splash_screens/splash_macos.png';
    if (Platform.isWindows) return 'asset/splash_screens/splash_windows.png';
    if (Platform.isLinux) return 'asset/splash_screens/splash_linux.png';
    return 'asset/splash_screens/splash_web.png';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: FadeTransition(
            opacity: _opacity,
            child: Image.asset(
              _assetPath,
              errorBuilder: (_, __, ___) => const FlutterLogo(size: 100),
            ),
          ),
        ),
      ),
    );
  }
}
