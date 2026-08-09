/// Route path constants used across feature packages.
///
/// These are just path segment strings. The actual GoRouter configuration
/// lives in the main app's routing.dart.
class RouteConstants {
  static const String home = '/home';
  static const String dashboard = 'dashboard';

  /// Dashboard routes
  static const String materialComponents = 'materialComponents';
  static const String cupertinoComponents = 'cupertinoComponents';
  static const String dialogs = 'dialogs';
  static const String implicitAnimations = 'implicitAnimations';
  static const String customImplicitAnimations = 'customImplicitAnimations';
  static const String explicitAnimations = 'explicitAnimations';
  static const String selectableText = 'selectableText';
  static const String tables = 'tables';
  static const String cardLayouts = 'cardLayouts';
  static const String stepper = 'stepper';
  static const String htmlRendering = 'htmlRendering';
}
