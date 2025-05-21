import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:sample_latest/core/mixins/loaders.dart';
import 'package:shimmer/shimmer.dart';

import '../../../shared/models/smart_control_model.dart';
import 'cubit/smart_device_mqtt_control_cubit.dart';

class SmartControlTile extends StatelessWidget with Loaders {
  final SmartControlMqttModel smartControlModel;

  final MqttServerClient mqttServerClient;

  const SmartControlTile(
      {super.key,
      required this.smartControlModel,
      required this.mqttServerClient});

  @override
  Widget build(BuildContext context) {
    final GetIt injector = GetIt.instance;
    mqttServerClient.connectionStatus;
    return BlocProvider<SmartDeviceMqttControlCubit>(
      create: (_) => injector<SmartDeviceMqttControlCubit>(
          param1: smartControlModel, param2: mqttServerClient),
      child: Builder(builder: (context) {
        context.read<SmartDeviceMqttControlCubit>().subscribeListener();
        return BlocBuilder<SmartDeviceMqttControlCubit, SmartDeviceState>(
            builder: (context, SmartDeviceState state) {
          if (state is SmartDeviceLoaded) {
            if (state.isShimmerEffectRequired) {
              return Shimmer.fromColors(
                  baseColor: Colors.black12,
                  highlightColor: Colors.white,
                  enabled: state.isShimmerEffectRequired,
                  child: _buildTile(state.smartDevice, state.isDisabled,
                      state.isShimmerEffectRequired));
            } else {
              return _buildTile(state.smartDevice, state.isDisabled,
                  state.isShimmerEffectRequired);
            }
          } else {
            return const SmartDeviceCardShimmer();
          }
        });
      }),
    );
  }

  Builder _buildTile(SmartControlMqttModel smartControl, bool isDisabled,
      bool isShimmerEffectRequired) {
    final isConnected = !isDisabled;
    final isOn = smartControl.isActive;
    final isAuto = smartControl.isAuto;

    return Builder(builder: (context) {
      final Color activeColor =
          isOn ? Colors.green.shade400 : Colors.blue.shade100;
      final Color disconnectedColor = Colors.grey.shade300;

      final Color backgroundColor =
          isConnected ? activeColor : disconnectedColor;
      final bool isDarkText =
          ThemeData.estimateBrightnessForColor(backgroundColor) ==
              Brightness.light;
      final Color textColor = isDarkText ? Colors.black87 : Colors.white;

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
                  Text(
                    smartControl.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                          isConnected ? textColor : textColor.withOpacity(0.5),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          !isAuto ? Icons.settings_remote : Icons.handyman,
                          color: isConnected
                              ? textColor
                              : textColor.withOpacity(0.5),
                        ),
                        tooltip: isAuto ? 'Auto Mode' : 'Manual Mode',
                        onPressed: isConnected
                            ? context
                                .read<SmartDeviceMqttControlCubit>()
                                .onSelectionOfAutoOrManual
                            : null,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: isConnected
                              ? textColor
                              : textColor.withOpacity(0.5),
                        ),
                        tooltip: 'Settings',
                        onPressed: isConnected ? onSettingsPressed : null,
                      ),
                    ],
                  )
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
    });
  }

  void onSettingsPressed() {}
}

class SmartDeviceCardShimmer extends StatelessWidget {
  const SmartDeviceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1, // Maintain square shape
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fake device name
              Container(
                width: 80,
                height: 18,
                color: Colors.grey,
              ),
              const Spacer(),
              // Icon row placeholders
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
