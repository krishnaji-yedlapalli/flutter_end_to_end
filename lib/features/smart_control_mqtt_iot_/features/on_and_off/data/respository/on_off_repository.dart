

import 'package:sample_latest/core/data/base_service.dart';

class OnOffRepository {

  final BaseService _baseService;

  final String baseUrl = 'http://192.168.1.9/';

  OnOffRepository(this._baseService);

  Future<bool> getStatus() async {
    var response = await _baseService.makeRequest(baseUrl: baseUrl, url: 'status');
    return int.parse(response) == 1 ? true : false;
  }

  Future<bool> on() async {
    var response = await _baseService.makeRequest(baseUrl: baseUrl,  url: 'turnOn');
    return int.parse(response) == 1 ? true : false;
  }

  Future<bool> off() async {
    var response = await _baseService.makeRequest(baseUrl: baseUrl, url: 'turnOff');
    return int.parse(response) == 1 ? true : false;
  }
}