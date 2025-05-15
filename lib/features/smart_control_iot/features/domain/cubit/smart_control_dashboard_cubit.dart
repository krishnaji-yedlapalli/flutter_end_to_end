
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../shared/models/smart_control_model.dart';
import '../../../shared/utils/enums.dart';
import '../../smart_device_control/domain/use_cases/device_status_useCase.dart';
import '../../smart_device_control/domain/use_cases/smart_device_ctrl_useCase.dart';
import '../../smart_device_control/presentation/cubit/smart_device_control_cubit.dart';

part 'smart_control_dashboard_state.dart';

class SmartControlDashboardCubit extends Cubit<ScDashboardState> {

  final SmartDeviceStatusUseCase _smartDeviceStatusUseCase;
  final SmartDeviceControlUseCase _smartDeviceControlUseCase;

  SmartControlDashboardCubit(this._smartDeviceStatusUseCase, this._smartDeviceControlUseCase) : super(SCDashboardLoading());

  final List<SmartControlModel> screenTypes =
  [
    SmartControlModel(
        'On and Off',
        SmartControlType.onOff,
        Icons.dashboard,
        'http://192.168.1.33/',
        des: 'We can on and off the light',
        tileType: TileSizeType.small,
    ),
    SmartControlModel(
        'On and Off',
        SmartControlType.motionDetector,
        Icons.dashboard,
        'http://192.168.1.8/',
        des: 'We can on and off the light',
        tileType: TileSizeType.small,
    ),
  ];

  Future<void> loadSmartControlDashboard() async {

    Map<String, SmartDeviceControlCubit> cubitList = {};
    for (var device in screenTypes) {
      cubitList[device.ipAddress] = SmartDeviceControlCubit(_smartDeviceStatusUseCase, _smartDeviceControlUseCase, device);
    }
    emit(SCDashboardLoaded(screenTypes, cubitList));
  }


}

