import 'package:flutter/material.dart';

import '../utils/enums.dart';

class SmartControlMqttModel {
  final String name;
  final String deviceId;
  final SmartControlType controlType;
  final IconData icon;
  String? des;
  final TileSizeType tileType;
  bool isActive;
  bool isDisabled;
  bool isAuto;

  SmartControlMqttModel(this.name, this.controlType, this.icon, this.deviceId,
      {this.des,
      this.tileType = TileSizeType.small,
      this.isActive = false,
      this.isDisabled = false, this.isAuto = false});
}
