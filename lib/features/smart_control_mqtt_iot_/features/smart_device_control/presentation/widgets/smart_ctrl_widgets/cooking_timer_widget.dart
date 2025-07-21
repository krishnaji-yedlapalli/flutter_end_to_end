
import 'package:flutter/material.dart';

import '../../../../../shared/models/smart_control_model.dart';
import '../smart_device_action_btn.dart';

class CookingTimerWidget extends StatelessWidget {
  const CookingTimerWidget(this.smartControl, this.isConnected, {super.key, this.onSettingsPressed});
  final SmartControlMqttModel smartControl;
  final bool isConnected;
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
