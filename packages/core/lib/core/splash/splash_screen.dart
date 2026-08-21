// Platform import is guarded by kIsWeb checks, so it is safe on all targets.
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show appFlavor;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  /// Total duration of the full splash sequence.
  /// Used by main.dart to know when it's safe to switch to MyApp.
  static const totalDuration = Duration(milliseconds: 7000);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _firstController;
  late final AnimationController _secondController;
  late final Animation<double> _firstOpacity;
  late final Animation<double> _secondOpacity;

  /// Resolved once — platform splash image path.
  late final String _primaryPath;

  /// Resolved after first frame — requires MediaQuery from build context.
  /// Null means no second image for this flavor/platform.
  String? _secondaryPath;

  /// Ensures the sequence is only started once.
  bool _sequenceStarted = false;

  static const _fadeDuration = Duration(milliseconds: 800);
  static const _holdDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();

    _primaryPath = _resolvePrimaryPath();

    _firstController = AnimationController(vsync: this, duration: _fadeDuration)
      ..forward();
    _firstOpacity =
        CurvedAnimation(parent: _firstController, curve: Curves.easeIn);

    _secondController =
        AnimationController(vsync: this, duration: _fadeDuration);
    _secondOpacity =
        CurvedAnimation(parent: _secondController, curve: Curves.easeIn);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // MediaQuery is available here — safe to resolve the secondary path.
    // Guard ensures the sequence only starts once even if dependencies change.
    if (!_sequenceStarted) {
      _secondaryPath = _resolveSecondaryPath(context);
      if (_secondaryPath != null) {
        _sequenceStarted = true;
        _startSequence();
      }
    }
  }

  Future<void> _startSequence() async {
    // Wait for first image to fade in + hold for 2s.
    await Future.delayed(_fadeDuration + _holdDuration);
    if (!mounted) return;

    // Fade out first image.
    await _firstController.reverse();
    if (!mounted) return;

    // Fade in second image.
    await _secondController.forward();
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  /// Returns the platform-specific splash image path.
  static String _resolvePrimaryPath() {
    if (kIsWeb) return 'asset/splash_screens/web/splash.png';
    if (Platform.isAndroid) return 'asset/splash_screens/android/splash.png';
    if (Platform.isIOS) return 'asset/splash_screens/ios/ios.png';
    if (Platform.isMacOS) return 'asset/splash_screens/mac/splash.png';
    if (Platform.isWindows) return 'asset/splash_screens/windows/splash.png';
    if (Platform.isLinux) return 'asset/splash_screens/linux/splash.png';
    return 'asset/splash_screens/web/splash.png';
  }

  /// Returns the flavor-specific second splash image path.
  /// MediaQuery is available here via [context] from [didChangeDependencies].
  /// Return null to skip the second image for that flavor.
  static String? _resolveSecondaryPath(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isPortrait = width < 600;

    if (kIsWeb) {
      return isPortrait
          ? 'asset/default_dash_flavor/flavor_splash_web/flavor_potrait_web.png'
          : 'asset/default_dash_flavor/flavor_splash_web/flavor_web_landscape.png';
    }

    final flavor = _resolveFlavor();
    return switch (flavor) {
      'flutter' => isPortrait
          ? 'asset/flutter_flavor/flavor_splash/flutter_flavor_potrait.png'
          : 'asset/flutter_flavor/flavor_splash/flutter_flavor_landscape.png',
      'dart' => isPortrait
          ? 'asset/dart_flavor/flavor_splash/dart_flavor_potrait.png'
          : 'asset/dart_flavor/flavor_splash/dart_flavor_landscape.png',
      'dash' => isPortrait
          ? 'asset/default_dash_flavor/flavor_splash/dash_flavor_potrait.png'
          : 'asset/default_dash_flavor/flavor_splash/dash_flavor_landscape.png',
      _ => null,
    };
  }

  /// Resolves the active flavor — mirrors Environment._resolveFlavor().
  static String _resolveFlavor() {
    if (appFlavor != null && appFlavor!.isNotEmpty) return appFlavor!;
    return const String.fromEnvironment('FLAVOR', defaultValue: 'dash');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // First (platform) splash image.
            FadeTransition(
              opacity: _firstOpacity,
              child: Image.asset(
                _primaryPath,
                errorBuilder: (_, __, ___) => const FlutterLogo(size: 100),
              ),
            ),

            // Second (flavor) splash image — only rendered if path is set.
            if (_secondaryPath != null)
              FadeTransition(
                opacity: _secondOpacity,
                child: Image.asset(
                  _secondaryPath!,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
