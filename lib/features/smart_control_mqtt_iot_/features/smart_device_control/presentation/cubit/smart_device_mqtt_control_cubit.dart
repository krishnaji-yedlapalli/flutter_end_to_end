import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import '../../../../shared/models/smart_control_model.dart';
import '../../domain/use_cases/device_status_useCase.dart';
import '../../domain/use_cases/smart_device_ctrl_useCase.dart';

part 'smart_device_control_state.dart';

class SmartDeviceMqttControlCubit extends Cubit<SmartDeviceState> {
  final SmartDeviceStatusUseCase _smartDeviceStatusUseCase;
  final SmartDeviceControlUseCase _smartDeviceControlUseCase;
  final SmartControlMqttModel _smartControlModel;
  final MqttServerClient _mqttServerClient;
  Subscription? _subscription;

  SmartDeviceMqttControlCubit(
      this._smartDeviceStatusUseCase,
      this._smartDeviceControlUseCase,
      this._smartControlModel,
      this._mqttServerClient)
      : super(SmartDeviceLoading());

  // Future<void> loadSmartDeviceStatus() async {
  //   emit(SmartDeviceLoading());
  //   var status =
  //       await _smartDeviceStatusUseCase.call(_smartControlModel.ipAddress);
  //   status.fold((status) {
  //     emit(SmartDeviceLoaded(_smartControlModel));
  //   }, (error) {
  //     if (DataErrorStateType.noInternet == error.$1) {
  //       emit(SmartDeviceLoaded(_smartControlModel, isDisabled: true));
  //     }
  //   });
  // }

  void subscribeListener() async  {
     // emit(SmartDeviceLoaded(_smartControlModel, isDisabled: true));

     if(_mqttServerClient.connectionStatus?.state != MqttConnectionState.connected){
       var res = await _mqttServerClient.connect();
     }

    _subscription = _mqttServerClient.subscribe(
        '${_smartControlModel.deviceId}/light/status', MqttQos.atMostOnce);
    _mqttServerClient.subscribe(
        '${_smartControlModel.deviceId}/deviceStatus', MqttQos.atMostOnce);

    _mqttServerClient.updates!
        .listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final topic = c[0].topic;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      if (topic.contains('light/status') &&
          _smartControlModel.deviceId == topic.split('/')[0]) {
        _smartControlModel.isActive = payload == 'ON' ? true : false;
        emit(SmartDeviceLoaded(_smartControlModel, isActive: _smartControlModel.isActive, isDisabled: false));
      }

      if (topic.contains('/deviceStatus') &&
          _smartControlModel.deviceId == topic.split('/')[0]) {
        final status = payload == 'online' ? true : false;
        emit(SmartDeviceLoaded(_smartControlModel, isDisabled: !status));
      }
    });

    await Future.delayed(const Duration(seconds: 2));
    if(!_smartControlModel.isActive){
      _requestStatus();
    }
  }

  Future<void> _requestStatus() async {
    final builder = MqttClientPayloadBuilder();
    builder.addString('status');
    _mqttServerClient.publishMessage(
        '${_smartControlModel.deviceId}/light/reqStatus', MqttQos.atMostOnce, builder.payload!);
  }

  Future<void> onSelectionOfSmartTile(SmartControlMqttModel device) async {
    final builder = MqttClientPayloadBuilder();
    if (device.isActive) {
      builder.addString('OFF');
    } else {
      builder.addString('ON');
    }
    _mqttServerClient.publishMessage(
        '${device.deviceId}/light/control', MqttQos.atMostOnce, builder.payload!);
  }

  Future<void> updateDeviceStatus(bool status) async {
    emit(SmartDeviceLoading());
    await Future.delayed(const Duration(seconds: 2));
    _smartControlModel.isActive = status;
    emit(SmartDeviceLoaded(_smartControlModel));
  }
}
