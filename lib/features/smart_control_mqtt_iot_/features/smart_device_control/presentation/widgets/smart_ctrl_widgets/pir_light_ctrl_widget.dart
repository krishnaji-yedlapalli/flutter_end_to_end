import 'package:flutter/material.dart';

import '../../../../../shared/mixins/smart_device_mixin.dart';
import '../../../../../shared/models/smart_control_model.dart';
import '../smart_device_action_btn.dart';

class PirLightCtrlWidget extends StatelessWidget with SmartDeviceMixin {
  const PirLightCtrlWidget(this.smartControl, this.isConnected, {super.key, this.onToggleAutoManual, this.onSettingsPressed});
  final SmartControlMqttModel smartControl;
  final bool isConnected;
  final VoidCallback? onToggleAutoManual;
  final VoidCallback? onSettingsPressed;

  @override
  Widget build(BuildContext context) {
    final isAuto = smartControl.isAuto;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 1,
          children: [
            Expanded(
                child: SmartDeviceActionButton(
                    icon: !isAuto ? Icons.settings_remote : Icons.handyman,
                    isConnected: isConnected,
                    toolTip: isAuto ? 'Auto Mode' : 'Manual Mode',
                    callBack: isConnected ? onToggleAutoManual : null)),
            Expanded(
                child: SmartDeviceActionButton(
              icon: Icons.settings,
              toolTip: 'Settings',
              isConnected: isConnected,
              callBack: isConnected ? onSettingsPressed : null,
            )),
          ],
        )
      ],
    );
  }
}

