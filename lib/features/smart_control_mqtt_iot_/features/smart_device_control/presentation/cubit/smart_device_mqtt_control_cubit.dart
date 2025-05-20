import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../shared/constants.dart';
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

  void subscribeListener() async  {
     // emit(SmartDeviceLoaded(_smartControlModel, isDisabled: true));

     if(_mqttServerClient.connectionStatus?.state != MqttConnectionState.connected){
       var res = await _mqttServerClient.connect();
     }

    _subscription = _mqttServerClient.subscribe(
        '${_smartControlModel.deviceId}${MqttConstants.status}', MqttQos.atMostOnce);
    _mqttServerClient.subscribe(
        '${_smartControlModel.deviceId}${MqttConstants.deviceConnectionStatus}', MqttQos.atMostOnce);

    _mqttServerClient.updates!
        .listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final topic = c[0].topic;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      if (topic.contains('${_smartControlModel.deviceId}${MqttConstants.status}') &&
          _smartControlModel.deviceId == topic.split('/')[0]) {
        _smartControlModel.isActive = payload == 'ON' ? true : false;
        emit(SmartDeviceLoaded(_smartControlModel, isActive: _smartControlModel.isActive, isDisabled: false));
      }

      if (topic.contains('${_smartControlModel.deviceId}${MqttConstants.deviceConnectionStatus}') &&
          _smartControlModel.deviceId == topic.split('/')[0]) {
        final status = payload == MqttConstants.onlineStatus ? true : false;
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
        '${_smartControlModel.deviceId}${MqttConstants.reqDeviceConnectionStatus}', MqttQos.atMostOnce, builder.payload!);
  }

  Future<void> onSelectionOfSmartTile(SmartControlMqttModel device) async {
    final builder = MqttClientPayloadBuilder();
    if (device.isActive) {
      builder.addString('OFF');
    } else {
      builder.addString('ON');
    }
    _mqttServerClient.publishMessage(
        '${device.deviceId}${MqttConstants.controlDevice}', MqttQos.atMostOnce, builder.payload!);
  }

  Future<void> updateDeviceStatus(bool status) async {
    emit(SmartDeviceLoading());
    await Future.delayed(const Duration(seconds: 2));
    _smartControlModel.isActive = status;
    emit(SmartDeviceLoaded(_smartControlModel));
  }
}
