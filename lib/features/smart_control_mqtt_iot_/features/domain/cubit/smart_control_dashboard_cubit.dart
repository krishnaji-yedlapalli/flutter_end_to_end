
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../../shared/models/smart_control_model.dart';
import '../../../shared/utils/enums.dart';
import '../../smart_device_control/domain/use_cases/device_status_useCase.dart';
import '../../smart_device_control/domain/use_cases/smart_device_ctrl_useCase.dart';
import '../../smart_device_control/presentation/cubit/smart_device_mqtt_control_cubit.dart';

part 'smart_control_dashboard_state.dart';

class SmartControlMqttDashboardCubit extends Cubit<ScDashboardState> {

  final SmartDeviceStatusUseCase _smartDeviceStatusUseCase;
  final SmartDeviceControlUseCase _smartDeviceControlUseCase;
  final MqttServerClient _mqttServerClient;

  SmartControlMqttDashboardCubit(this._smartDeviceStatusUseCase, this._smartDeviceControlUseCase, this._mqttServerClient) : super(SCDashboardLoading());

  final List<SmartControlMqttModel> screenTypes =
  [
    SmartControlMqttModel(
        'On and Off',
        SmartControlType.onOff,
        Icons.dashboard,
        'node1',
        des: 'We can on and off the light',
        tileType: TileSizeType.small,
    ),
    SmartControlMqttModel(
        'On and Off',
        SmartControlType.motionDetector,
        Icons.dashboard,
        'node2',
        des: 'We can on and off the light',
        tileType: TileSizeType.small,
    ),
  ];

  Future<void> loadSmartControlDashboard() async {
    emit(SCDashboardLoaded(screenTypes, _mqttServerClient));
  }


}

