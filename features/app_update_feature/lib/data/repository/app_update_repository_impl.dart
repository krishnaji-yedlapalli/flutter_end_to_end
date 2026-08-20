import 'dart:io';

import 'package:app_core/core/firebase/config/remote_config_keys.dart';
import 'package:app_core/core/firebase/services/firebase_remote_config_service.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../domain/entities/app_update_result.dart';
import '../../domain/repository/app_update_repository.dart';
import '../utils/os_version_parser.dart';
import '../utils/version_comparator.dart';

class AppUpdateRepositoryImpl implements AppUpdateRepository {
  final FirebaseRemoteConfigService _remoteConfigService;

  AppUpdateRepositoryImpl(this._remoteConfigService);

  static const String _defaultUpdateUrl = 'https://example.com/update';

  @override
  Future<AppUpdateResult> checkForUpdate() async {
    final osVersion = await OsVersionParser.getCurrentOsVersion();
    final packageInfo = await PackageInfo.fromPlatform();

    return _evaluateUpdate(
      currentOsVersion: osVersion.toString(),
      currentAppVersion: packageInfo.version,
    );
  }

  @override
  Future<AppUpdateResult> checkWithSimulatedValues({
    required String osVersion,
    required String appVersion,
  }) async {
    return _evaluateUpdate(
      currentOsVersion: osVersion,
      currentAppVersion: appVersion,
    );
  }

  AppUpdateResult _evaluateUpdate({
    required String currentOsVersion,
    required String currentAppVersion,
  }) {
    final minOsVersion = _getMinSupportedOsVersion();
    final minAppVersion =
        _remoteConfigService.getString(RemoteConfigKeys.minSupportedAppVersion);
    final latestAppVersion =
        _remoteConfigService.getString(RemoteConfigKeys.latestAppVersion);
    final updateUrl =
        _remoteConfigService.getString(RemoteConfigKeys.appUpdateUrl);

    final effectiveUpdateUrl =
        updateUrl.isNotEmpty ? updateUrl : _defaultUpdateUrl;
    final effectiveMinOsVersion = minOsVersion.isNotEmpty ? minOsVersion : '0';
    final effectiveMinAppVersion =
        minAppVersion.isNotEmpty ? minAppVersion : '0.0.0';
    final effectiveLatestAppVersion =
        latestAppVersion.isNotEmpty ? latestAppVersion : currentAppVersion;

    // Step 1: Check OS compatibility
    if (VersionComparator.isLessThan(currentOsVersion, effectiveMinOsVersion)) {
      return AppUpdateResult(
        status: AppUpdateStatus.osUnsupported,
        currentOsVersion: currentOsVersion,
        minSupportedOsVersion: effectiveMinOsVersion,
        currentAppVersion: currentAppVersion,
        minSupportedAppVersion: effectiveMinAppVersion,
        latestAppVersion: effectiveLatestAppVersion,
        updateUrl: effectiveUpdateUrl,
      );
    }

    // Step 2: Check if force update is required
    if (VersionComparator.isLessThan(
        currentAppVersion, effectiveMinAppVersion)) {
      return AppUpdateResult(
        status: AppUpdateStatus.forceUpdateRequired,
        currentOsVersion: currentOsVersion,
        minSupportedOsVersion: effectiveMinOsVersion,
        currentAppVersion: currentAppVersion,
        minSupportedAppVersion: effectiveMinAppVersion,
        latestAppVersion: effectiveLatestAppVersion,
        updateUrl: effectiveUpdateUrl,
      );
    }

    // Step 3: Check if flexible update is available
    if (VersionComparator.isLessThan(
        currentAppVersion, effectiveLatestAppVersion)) {
      return AppUpdateResult(
        status: AppUpdateStatus.flexibleUpdateAvailable,
        currentOsVersion: currentOsVersion,
        minSupportedOsVersion: effectiveMinOsVersion,
        currentAppVersion: currentAppVersion,
        minSupportedAppVersion: effectiveMinAppVersion,
        latestAppVersion: effectiveLatestAppVersion,
        updateUrl: effectiveUpdateUrl,
      );
    }

    // Step 4: App is up to date
    return AppUpdateResult(
      status: AppUpdateStatus.upToDate,
      currentOsVersion: currentOsVersion,
      minSupportedOsVersion: effectiveMinOsVersion,
      currentAppVersion: currentAppVersion,
      minSupportedAppVersion: effectiveMinAppVersion,
      latestAppVersion: effectiveLatestAppVersion,
      updateUrl: effectiveUpdateUrl,
    );
  }

  String _getMinSupportedOsVersion() {
    if (kIsWeb) {
      return _remoteConfigService
          .getString(RemoteConfigKeys.minSupportedOsVersionWeb);
    } else if (Platform.isAndroid) {
      return _remoteConfigService
          .getString(RemoteConfigKeys.minSupportedOsVersionAndroid);
    } else if (Platform.isIOS) {
      return _remoteConfigService
          .getString(RemoteConfigKeys.minSupportedOsVersionIos);
    } else if (Platform.isMacOS) {
      return _remoteConfigService
          .getString(RemoteConfigKeys.minSupportedOsVersionMacos);
    }
    return '';
  }
}
