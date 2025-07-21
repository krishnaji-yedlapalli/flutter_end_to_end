
import 'package:flutter/material.dart';

import '../../../../../shared/models/smart_control_model.dart';

class GasDetectorStatusWidget extends StatelessWidget {
  const GasDetectorStatusWidget(this.smartControlMqttModel, this.isConnected, {super.key, this.onSettingsPressed});
  final SmartControlMqttModel smartControlMqttModel;
  final bool isConnected;
  final VoidCallback? onSettingsPressed;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
