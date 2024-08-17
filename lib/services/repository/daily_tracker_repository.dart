
import 'package:sample_latest/models/daily_tracker/daily_tracker_event_model.dart';

import '../base_service.dart';
import '../urls.dart';
import '../utils/service_enums_typedef.dart';

abstract class DailyTrackerRepo {

  Future<(bool, List<DailyTrackerEventModel>)> isCheckedIn(String date);
  Future<bool> checkInTheUser(Map body);
  Future<DailyTrackerEventModel> createOrEditEvent(DailyTrackerEventModel event);
  Future<List<DailyTrackerEventModel>> fetchEventList();
  Future<bool> deleteEvent(String eventId);
  }

class DailyTrackerRepository extends DailyTrackerRepo {

  final BaseService baseService;

  DailyTrackerRepository({BaseService? baseService}) : baseService = baseService ?? BaseService.instance;

  @override
  Future<(bool, List<DailyTrackerEventModel>)> isCheckedIn(String date) async {

    var events = <DailyTrackerEventModel>[];

    var response = await baseService.makeRequest(url: '${Urls.dailyCheckIns}/$date.json');
    if(response != null && response['events'] != null) {
      events = response['events'].map<DailyTrackerEventModel>((json) => DailyTrackerEventModel.fromJson(json)).toList();
    }
    return ((response?['isChecked'] as bool?) ?? false, events);
  }

  @override
  Future<bool> checkInTheUser(Map body) async {
    var response = await baseService.makeRequest(url: '${Urls.dailyCheckIns}.json', body: body, method: RequestType.patch);
    if(response != null) {
      return true;
    }
    return false;
  }

  @override
  Future<DailyTrackerEventModel> createOrEditEvent(DailyTrackerEventModel event) async {

    var body = {
      event.id : event.toJson()
    };

    var response = await baseService.makeRequest(url: '${Urls.events}.json', body: body, method: RequestType.patch);
    if(response != null && response is Map && response.keys.isNotEmpty) {
      event = DailyTrackerEventModel.fromJson(response[response.keys.first]);
    }
    return event;
  }

  @override
  Future<List<DailyTrackerEventModel>> fetchEventList() async {
    List<DailyTrackerEventModel> events = <DailyTrackerEventModel>[];
    var response = await baseService.makeRequest(url: '${Urls.events}.json');
    if(response is Map) {
      events = response.entries.map<DailyTrackerEventModel>((json) => DailyTrackerEventModel.fromJson(json.value)).toList();
    }else if(response is List){
      events = response.map<DailyTrackerEventModel>((json) => DailyTrackerEventModel.fromJson(json)).toList();
    }
    return events;
  }

  @override
  Future<bool> deleteEvent(String eventId) async {
    var status = await baseService.makeRequest(url: '${Urls.events}/$eventId.json', method: RequestType.delete);
    return true;
  }

}