import 'package:flutter/material.dart';

import '../utils/enums.dart';

class SmartControlMqttModel {
  final String name;
  final String deviceId;
  final SmartControlType controlType;
  final IconData icon;
  String? des;
  final TileSizeType tileType;
  final String ipAddress;
  bool isActive;
  bool isDisabled;

  SmartControlMqttModel(this.name, this.controlType, this.icon, this.ipAddress, this.deviceId,
      {this.des,
      this.tileType = TileSizeType.small,
      this.isActive = false,
      this.isDisabled = false,});
}
