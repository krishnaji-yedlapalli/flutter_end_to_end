import 'package:flutter/material.dart';

import '../../features/smart_device_control/presentation/cubit/smart_device_control_cubit.dart';
import '../utils/enums.dart';

class SmartControlModel {
  final String name;
  final SmartControlType controlType;
  final IconData icon;
  String? des;
  final TileSizeType tileType;
  final String ipAddress;
  bool isActive;
  bool isDisabled;

  SmartControlModel(this.name, this.controlType, this.icon, this.ipAddress,
      {this.des,
      this.tileType = TileSizeType.small,
      this.isActive = false,
      this.isDisabled = false,});
}
