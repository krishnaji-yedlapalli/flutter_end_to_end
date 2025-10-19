import 'package:flutter/material.dart';

import '../../../../../shared/models/smart_control_model.dart';

class WaterTankStatusWidget extends StatelessWidget {
  const WaterTankStatusWidget(this.smartControl, this.isConnected,
      {super.key, this.onSettingsPressed});
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
      ],
    );
  }
}
