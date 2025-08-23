
import 'package:flutter/material.dart';

import '../models/smart_control_model.dart';

mixin SmartDeviceMixin {

  BoxDecoration get boxDecoration => BoxDecoration(
    shape: BoxShape.circle,
    gradient: RadialGradient(
      colors: [
        Colors.blue.withOpacity(0.3),
        Colors.transparent,
      ],
      center: Alignment.center,
      radius: 0.6,
    ),
  );

  Color textColor(bool isActive, bool isConnected) {

    final Color activeColor =
    isActive ? Colors.green.shade400 : Colors.blue.shade100;
    final Color disconnectedColor = Colors.grey.shade300;

    final Color backgroundColor =
    isConnected ? activeColor : disconnectedColor;
    final bool isDarkText =
        ThemeData.estimateBrightnessForColor(backgroundColor) ==
            Brightness.light;
    return isDarkText ? Colors.black87 : Colors.white;
  }
}