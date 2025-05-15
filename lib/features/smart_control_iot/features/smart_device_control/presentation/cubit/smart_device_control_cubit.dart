import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import '../../../../shared/models/smart_control_model.dart';
import '../../domain/use_cases/device_status_useCase.dart';
import '../../domain/use_cases/smart_device_ctrl_useCase.dart';

part 'smart_device_control_state.dart';

class SmartDeviceControlCubit extends Cubit<SmartDeviceState> {
  final SmartDeviceStatusUseCase _smartDeviceStatusUseCase;
  final SmartDeviceControlUseCase _smartDeviceControlUseCase;
  final SmartControlModel _smartControlModel;

  SmartDeviceControlCubit(this._smartDeviceStatusUseCase,
      this._smartDeviceControlUseCase, this._smartControlModel)
      : super(SmartDeviceLoading());

  Future<void> loadSmartDeviceStatus() async {
    emit(SmartDeviceLoading());
    var status =
        await _smartDeviceStatusUseCase.call(_smartControlModel.ipAddress);
    status.fold((status) {
      emit(SmartDeviceLoaded(_smartControlModel));
    }, (error) {
      if (DataErrorStateType.noInternet == error.$1) {
        emit(SmartDeviceLoaded(_smartControlModel, isDisabled: true));
      }
    });
  }

  Future<void> onSelectionOfSmartTile(SmartControlModel device) async {
    emit(SmartDeviceLoading());
    var res = await _smartDeviceControlUseCase.call(
        device.ipAddress, !device.isActive);
    res.fold((status) {
      _smartControlModel.isActive = status;
      emit(SmartDeviceLoaded(_smartControlModel));
    }, (error) {
      if (DataErrorStateType.noInternet == error.$1) {
        emit(SmartDeviceLoaded(_smartControlModel, isDisabled: true));
      }
    });
  }

  Future<void> updateDeviceStatus(bool status) async {
    emit(SmartDeviceLoading());
    await Future.delayed(const Duration(seconds: 2));
    _smartControlModel.isActive = status;
    emit(SmartDeviceLoaded(_smartControlModel));
  }
}
