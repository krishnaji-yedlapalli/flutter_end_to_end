import 'package:equatable/equatable.dart';

enum AppUpdateStatus {
  osUnsupported,
  forceUpdateRequired,
  flexibleUpdateAvailable,
  upToDate,
}

class AppUpdateResult extends Equatable {
  final AppUpdateStatus status;
  final String currentOsVersion;
  final String minSupportedOsVersion;
  final String currentAppVersion;
  final String minSupportedAppVersion;
  final String latestAppVersion;
  final String updateUrl;

  const AppUpdateResult({
    required this.status,
    required this.currentOsVersion,
    required this.minSupportedOsVersion,
    required this.currentAppVersion,
    required this.minSupportedAppVersion,
    required this.latestAppVersion,
    required this.updateUrl,
  });

  @override
  List<Object?> get props => [
        status,
        currentOsVersion,
        minSupportedOsVersion,
        currentAppVersion,
        minSupportedAppVersion,
        latestAppVersion,
        updateUrl,
      ];
}
