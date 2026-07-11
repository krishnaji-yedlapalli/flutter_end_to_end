enum EnvironmentType {
  dash,
  flutter,
  dart,
  dailyTracker;

  static EnvironmentType fromFlavor(String flavor) {
    if (flavor == 'flutter') return EnvironmentType.flutter;
    if (flavor == 'dart') return EnvironmentType.dart;
    if (flavor == 'dailyTracker') return EnvironmentType.dailyTracker;
    return defaultEnvironment;
  }
}

const defaultEnvironment = EnvironmentType.dash;
