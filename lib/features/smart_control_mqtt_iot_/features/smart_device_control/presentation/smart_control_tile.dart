import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:sample_latest/core/mixins/loaders.dart';

import '../../../shared/models/smart_control_model.dart';
import 'cubit/smart_device_mqtt_control_cubit.dart';

class SmartControlTile extends StatelessWidget with Loaders {
  final SmartControlMqttModel smartControlModel;

  final MqttServerClient mqttServerClient;


  const SmartControlTile(
      {super.key,
      required this.smartControlModel, required this.mqttServerClient});

  @override
  Widget build(BuildContext context) {
    final GetIt injector = GetIt.instance;
    mqttServerClient.connectionStatus;
    return BlocProvider<SmartDeviceMqttControlCubit>(
      create: (_)=> injector<SmartDeviceMqttControlCubit>(param1: smartControlModel, param2: mqttServerClient),
      child: Builder(builder: (context) {
        context.read<SmartDeviceMqttControlCubit>().subscribeListener();
        return BlocBuilder<SmartDeviceMqttControlCubit, SmartDeviceState>(
            builder: (context, SmartDeviceState state) {
          if (state is SmartDeviceLoaded) {
            return _buildTile(state.smartDevice, state.isDisabled);
          } else {
            return circularLoader();
          }
        });
      }),
    );
  }

  Builder _buildTile(SmartControlMqttModel smartControl, bool isDisabled) {
    return Builder(builder: (context) {
      return Container(
        decoration: BoxDecoration(
            color: isDisabled
                ? Colors.grey
                : smartControl.isActive
                    ? Colors.green
                    : Colors.brown,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: InkWell(
          onTap: isDisabled ? null :  () {
            context
                .read<SmartDeviceMqttControlCubit>()
                .onSelectionOfSmartTile(smartControl);
          },
          child: Stack(
            children: [
              if(isDisabled) Container(
                color: Colors.black12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to connect', style: TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(onPressed: (){
                      // context.read<SmartDeviceMqttControlCubit>().loadSmartDeviceStatus();
                    }, icon: const Icon(Icons.refresh))
                  ],
                ),
              ),
              Opacity(
                opacity: isDisabled ? 0.2 : 1,
                child: Column(
                  children: [
                    Text('name : ${smartControl.name}'),
                    Text('des : ${smartControl.des}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
