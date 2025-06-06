import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../enums/device_enums.dart';
import '../utils/screen_break_points.dart';

class DeviceConfiguration {
  DeviceConfiguration.initiate() {
    if (kIsWeb) {
      _operatingType = OperatingSystemType.web;
      _applicationType = ApplicationType.web;
    } else {
      _operatingType = OperatingSystemType.values.firstWhere((operatingType) =>
          operatingType.toString() ==
          'OperatingSystemType.${Platform.operatingSystem}');

      if (Platform.isIOS || Platform.isAndroid) {
        _applicationType = ApplicationType.mobile;
      } else if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
        _applicationType = ApplicationType.desktop;
      }
    }
  }

  static void updateDeviceResolutionAndOrientation(
      Size size, Orientation orientation) {
    _orientationType = orientation;

    if (ScreenBreakPoints.isMobile(size)) {
      _deviceResolutionType = DeviceResolutionType.mobile;
    } else if (ScreenBreakPoints.isDesktop(size)) {
      _deviceResolutionType = DeviceResolutionType.desktop;
    } else {
      _deviceResolutionType = DeviceResolutionType.tab;
    }
  }

  /// Device types =>  mobile, foldedMobile, tab, desktop, watch, tv
  static late OperatingSystemType _operatingType;

  ////
  static late DeviceResolutionType _deviceResolutionType;

  ///
  static late ApplicationType _applicationType;

  ///
  static late Orientation _orientationType;

  static bool get isMobileResolution =>
      _deviceResolutionType == DeviceResolutionType.mobile;

  static bool get isDesktopResolution =>
      _deviceResolutionType == DeviceResolutionType.desktop;

  static bool get isTabResolution =>
      _deviceResolutionType == DeviceResolutionType.tab;

  static DeviceResolutionType get resolutionType => _deviceResolutionType;

  static bool get isPortrait => _orientationType == Orientation.portrait;

  static bool get isWeb => _applicationType == ApplicationType.web;

  static OperatingSystemType get operatingSystemType => _operatingType;

  static bool get isiPhone => _operatingType == OperatingSystemType.ios;

  static bool get isOfflineSupportedDevice {
    if (kIsWeb) return false;
    return Platform.isIOS || Platform.isMacOS || Platform.isAndroid;
  }
}
