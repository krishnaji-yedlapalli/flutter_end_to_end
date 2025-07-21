
import 'package:flutter/material.dart';

import '../../../../shared/mixins/smart_device_mixin.dart';

class SmartDeviceActionButton extends StatelessWidget with SmartDeviceMixin{

  const SmartDeviceActionButton({ super.key, required this.icon, this.isConnected = false, this.isActive = false, this.toolTip, this.callBack});

  final IconData icon;

  final bool isConnected;

  final bool isActive;

  final String? toolTip;

  final VoidCallback? callBack;

  @override
  Widget build(BuildContext context) {
    final fontColor = textColor(isActive, isConnected);
    return Container(
      decoration: boxDecoration,
      child: IconButton(
        icon: Icon(
          icon,
          color: isConnected
              ? fontColor
              : fontColor.withOpacity(0.5),
        ),
        tooltip: toolTip,
        onPressed: callBack
      ),
    );
  }
}
