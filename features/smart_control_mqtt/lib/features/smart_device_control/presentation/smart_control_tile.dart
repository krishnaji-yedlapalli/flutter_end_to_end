import 'package:ui_kit/mixins/mixins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_control_mqtt/features/smart_device_control/presentation/widgets/smart_device_card.dart';

import '../../../shared/models/smart_control_model.dart';
import 'cubit/smart_device_mqtt_control_cubit.dart';
import 'dialogs/settings.dart';

class SmartControlTile extends StatelessWidget with Loaders, CustomDialogs {
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
                  child: SmartDeviceCard(
                      smartControl: state.smartDevice,
                      isDisabled: state.isDisabled,
                      isShimmerEffectRequired: state.isShimmerEffectRequired));
            } else {
              return SmartDeviceCard(
                smartControl: state.smartDevice,
                isDisabled: state.isDisabled,
                onToggleAutoManual: context
                    .read<SmartDeviceMqttControlCubit>()
                    .onSelectionOfAutoOrManual,
                onSettingsPressed: () =>
                    onSettingsPressed(context, state.smartDevice),
              );
            }
          } else {
            return const SmartDeviceCardShimmer();
          }
        });
      }),
    );
  }

  void onSettingsPressed(
      BuildContext context, SmartControlMqttModel smartControl) {
    adaptiveDialog(context, SmartDeviceSetting(context, smartControl));
  }
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
