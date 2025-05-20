
part of 'smart_device_mqtt_control_cubit.dart';


abstract class SmartDeviceState extends Equatable {

}

class SmartDeviceLoading extends SmartDeviceState {
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class SmartDeviceLoaded extends SmartDeviceState {

  final SmartControlMqttModel smartDevice;
  final bool isDisabled;
  final bool isActive;

  SmartDeviceLoaded(this.smartDevice, {this.isActive = false, this.isDisabled = false});

  @override
  // TODO: implement props
  List<Object?> get props => [smartDevice,isActive, isDisabled];

}