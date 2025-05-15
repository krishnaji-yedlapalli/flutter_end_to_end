

import 'package:sample_latest/core/data/base_service.dart';
import 'package:sample_latest/features/smart_control_iot/features/smart_device_control/domain/repository/smart_device_control_repo.dart';

class SmartDeviceControlRepositoryImpl implements SmartDeviceControlRepository{

  final BaseService _baseService;

  final String baseUrl = 'http://192.168.1.37/';

  SmartDeviceControlRepositoryImpl(this._baseService);

  @override
  Future<bool> getStatus(String ip) async {
    var response = await _baseService.makeRequest(baseUrl: ip, url: 'status');
    return int.parse(response) == 1 ? true : false;
  }

  @override
  Future<bool> on(String ip) async {
    var response = await _baseService.makeRequest(baseUrl: ip,  url: 'turnOn');
    return int.parse(response) == 1 ? true : false;
  }

  @override
  Future<bool> off(String ip) async {
    var response = await _baseService.makeRequest(baseUrl: ip, url: 'turnOff');
    return int.parse(response) == 1 ? true : false;
  }
}