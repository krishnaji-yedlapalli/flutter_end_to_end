import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_control_mqtt/shared/mixins/smart_device_mixin.dart';
import 'package:smart_control_mqtt/shared/models/smart_control_model.dart';
import 'package:smart_control_mqtt/shared/utils/enums.dart';

import '../cubit/smart_device_mqtt_control_cubit.dart';
import 'smart_ctrl_widgets/control_widgets.dart';

class SmartDeviceCard extends StatelessWidget with SmartDeviceMixin {
  final SmartControlMqttModel smartControl;
  final bool isDisabled;
  final bool isShimmerEffectRequired;
  final VoidCallback? onToggleAutoManual;
  final VoidCallback? onSettingsPressed;

  const SmartDeviceCard({
    super.key,
    required this.smartControl,
    required this.isDisabled,
    this.isShimmerEffectRequired = false,
    this.onToggleAutoManual,
    this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isConnected = !isDisabled;
    final isOn = smartControl.isEngaged;

    final Color activeColor =
        isOn ? Colors.green.shade400 : Colors.blue.shade100;
    final Color disconnectedColor = Colors.grey.shade300;

    final Color backgroundColor = isConnected ? activeColor : disconnectedColor;
    final Color textColorValue = textColor(isOn, isConnected);

    return AspectRatio(
      aspectRatio: 1, // makes it square
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isShimmerEffectRequired
                  ? null
                  : isConnected
                      ? backgroundColor
                      : backgroundColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(smartControl.name,
                    style: TextStyle(
                        color: textColorValue, fontWeight: FontWeight.bold)),
                Expanded(
                  child: InkWell(
                    onTap: context
                        .read<SmartDeviceMqttControlCubit>()
                        .onSelectionOfSmartTile,
                    child: switch (smartControl.controlType) {
                      SmartControlType.pirLight => PirLightCtrlWidget(
                          smartControl, isConnected,
                          onToggleAutoManual: onToggleAutoManual,
                          onSettingsPressed: onSettingsPressed),
                      SmartControlType.diodeLight => DiodeLightCtrlWidget(
                          smartControl, isConnected,
                          onToggleAutoManual: onToggleAutoManual,
                          onSettingsPressed: onSettingsPressed),
                      SmartControlType.exhaustFan => ExhaustFanCtrlWidget(
                          smartControl, isConnected,
                          onToggleAutoManual: onToggleAutoManual,
                          onSettingsPressed: onSettingsPressed),
                      SmartControlType.waterLevel => WaterTankStatusWidget(
                          smartControl, isConnected,
                          onSettingsPressed: onSettingsPressed),
                      SmartControlType.gasDetector => GasDetectorStatusWidget(
                          smartControl, isConnected,
                          onSettingsPressed: onSettingsPressed),
                      SmartControlType.scheduledDevice =>
                        ScheduledDeviceControlWidget(smartControl, isConnected,
                            onToggleAutoManual: onToggleAutoManual,
                            onSettingsPressed: onSettingsPressed),
                      SmartControlType.cookingTimer => CookingTimerWidget(
                          smartControl, isConnected,
                          onSettingsPressed: onSettingsPressed),
                    },
                  ),
                ),
              ],
            ),
          ),
          if (!isConnected)
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.1),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_off, color: Colors.redAccent),
                    SizedBox(height: 4),
                    Text(
                      "Not Connected",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
