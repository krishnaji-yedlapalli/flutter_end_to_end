
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sample_latest/utils/enums_type_def.dart';

class DeviceConfiguration {

  DeviceConfiguration.initiate() {

    if(kIsWeb){
      _operatingType = OperatingSystemType.web;
      _applicationType = ApplicationType.web;
    }else {
      _operatingType = OperatingSystemType.values.firstWhere((operatingType) => operatingType.toString() == 'OperatingSystemType.${Platform.operatingSystem}');

      if(Platform.isIOS || Platform.isAndroid){
        _applicationType = ApplicationType.mobile;
      }else if(Platform.isMacOS || Platform.isLinux || Platform.isWindows){
        _applicationType = ApplicationType.desktop;
      }
    }
  }

  static void updateDeviceResolutionAndOrientation(BuildContext context, Orientation orientation) {
    _orientationType = orientation;
    double size = MediaQuery.of(context).size.width;

    if(size < 600){
      _deviceResolutionType = DeviceResolutionType.mobile;
    }else if(size > 1280) {
      _deviceResolutionType = DeviceResolutionType.desktop;
    }else{
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

  static bool get isMobileResolution =>  _deviceResolutionType == DeviceResolutionType.mobile;

  static DeviceResolutionType get resolutionType =>  _deviceResolutionType;

  static bool get isPortrait =>  _orientationType == Orientation.portrait;

  static bool get isWeb =>  _applicationType == ApplicationType.web;

  static bool get isOfflineSupportedDevice {
    if(kIsWeb) return false;
    return Platform.isIOS || Platform.isMacOS || Platform.isAndroid;
  }
}