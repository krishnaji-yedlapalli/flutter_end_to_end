
part of 'smart_device_control_cubit.dart';


abstract class SmartDeviceState extends Equatable {

}

class SmartDeviceLoading extends SmartDeviceState {
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class SmartDeviceLoaded extends SmartDeviceState {

  final SmartControlModel smartDevice;
  final bool isDisabled;

  SmartDeviceLoaded(this.smartDevice, {this.isDisabled = false});

  @override
  // TODO: implement props
  List<Object?> get props => [];

}