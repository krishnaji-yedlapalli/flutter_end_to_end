import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../../shared/models/smart_control_model.dart';
import '../../../shared/utils/enums.dart';
import '../../mock/smart_control_seed.dart';
import '../../smart_device_control/domain/use_cases/device_status_useCase.dart';
import '../../smart_device_control/domain/use_cases/smart_device_ctrl_useCase.dart';
import '../../smart_device_control/presentation/cubit/smart_device_mqtt_control_cubit.dart';

part 'smart_control_dashboard_state.dart';

class SmartControlMqttDashboardCubit extends Cubit<ScDashboardState> {
  final SmartDeviceStatusUseCase _smartDeviceStatusUseCase;
  final SmartDeviceControlUseCase _smartDeviceControlUseCase;
  final MqttServerClient _mqttServerClient;

  SmartControlMqttDashboardCubit(this._smartDeviceStatusUseCase,
      this._smartDeviceControlUseCase, this._mqttServerClient)
      : super(SCDashboardLoading());

  Future<void> loadSmartControlDashboard() async {
    emit(SCDashboardLoaded(SmartControlSeed.dashboardSeed, _mqttServerClient));
  }
}
