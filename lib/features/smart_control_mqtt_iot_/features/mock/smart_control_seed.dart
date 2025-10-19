import 'package:flutter/material.dart';
import 'package:sample_latest/features/smart_control_mqtt_iot_/shared/utils/enums.dart';

import '../../shared/models/smart_control_model.dart';

sealed class SmartControlSeed {
  static final dashboardSeed = [
    SmartControlMqttModel(
      'Office Work light',
      SmartControlType.pirLight,
      Icons.dashboard,
      'node1',
      des: 'We can on and off the light',
      tileType: TileSizeType.small,
    ),
    SmartControlMqttModel(
      'Compound Light',
      SmartControlType.diodeLight,
      Icons.dashboard,
      'node2',
      des: 'We can on and off the light',
      tileType: TileSizeType.small,
    ),
    SmartControlMqttModel(
      'Kitchen Exhaust Fan',
      SmartControlType.exhaustFan,
      Icons.dashboard,
      'node3',
      des: 'We can on and off the light',
      tileType: TileSizeType.small,
    ),
    SmartControlMqttModel(
      'Router Status',
      SmartControlType.scheduledDevice,
      Icons.dashboard,
      'node4',
      des: 'We can on and off the light',
      tileType: TileSizeType.small,
    ),
    SmartControlMqttModel(
      'Gas Status',
      SmartControlType.gasDetector,
      Icons.dashboard,
      'node4',
      des: 'We can on and off the light',
      tileType: TileSizeType.medium,
    ),
    SmartControlMqttModel(
      'Water Tank Level',
      SmartControlType.waterLevel,
      Icons.dashboard,
      'node4',
      des: 'We can on and off the light',
      tileType: TileSizeType.medium,
    ),
    SmartControlMqttModel(
      'Cooking Timer',
      SmartControlType.cookingTimer,
      Icons.dashboard,
      'node4',
      des: 'We can on and off the light',
      tileType: TileSizeType.large,
    ),
  ];
}
