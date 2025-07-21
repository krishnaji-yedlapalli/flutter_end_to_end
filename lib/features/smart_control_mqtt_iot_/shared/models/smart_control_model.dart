import 'package:flutter/material.dart';

import '../utils/enums.dart';

class SmartControlMqttModel {
  /// The display name of the smart device (e.g., "Living Room Light").
  final String name;

  /// A unique identifier for the device, used for MQTT communication.
  final String deviceId;

  /// The type of smart device (e.g., Light, Fan, Sensor).
  final SmartControlType controlType;

  /// The icon to be displayed for this device in the UI.
  final IconData icon;

  /// An optional description for the device.
  String? des;

  /// The size of the UI tile for this device.
  final TileSizeType tileType;

  /// Whether the device is actively performing its function (e.g., the light is on).
  bool isEngaged;

  /// Whether the device is offline or cannot be reached by the MQTT server.
  bool isDeviceUnReachable;

  /// Whether the device is in an automatic mode (e.g., a light controlled by a motion sensor).
  bool isAuto;

  /// A timer or schedule-related value, possibly in seconds or minutes.
  int? time;

  SmartControlMqttModel(this.name, this.controlType, this.icon, this.deviceId,
      {this.des,
      this.tileType = TileSizeType.small,
      this.isEngaged = false,
      this.isDeviceUnReachable = true, this.isAuto = true, this.time});
}