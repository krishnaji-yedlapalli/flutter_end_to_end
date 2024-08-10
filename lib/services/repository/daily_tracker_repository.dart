
import 'package:sample_latest/models/daily_tracker/daily_tracker_event_model.dart';

import '../base_service.dart';
import '../urls.dart';
import '../utils/service_enums_typedef.dart';

abstract class DailyTrackerRepo {

  Future<bool> isCheckedIn(String date);
  Future<bool> checkInTheUser(Map body);
  Future<DailyTrackerEventModel> createOrEditEvent(DailyTrackerEventModel event);
}

class DailyTrackerRepository extends DailyTrackerRepo {

  final BaseService baseService;

  DailyTrackerRepository({BaseService? baseService}) : baseService = baseService ?? BaseService.instance;

  @override
  Future<bool> isCheckedIn(String date) async {
    var response = await baseService.makeRequest(url: '${Urls.dailyCheckIns}/$date.json');
    if(response != null && response) {
      return response;
    }
    return false;
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
    var response = await baseService.makeRequest(url: '${Urls.events}.json', body: event.toJson(), method: RequestType.patch);
    if(response != null && response is Map && response.keys.isNotEmpty) {
      event = DailyTrackerEventModel.fromJson(response[response.keys.first]);
    }
    return event;
  }



}