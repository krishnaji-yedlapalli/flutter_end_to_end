
import 'package:sample_latest/core/data/base_service.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';

import '../../../../core/data/urls.dart';
import '../../domain/repository/events_repository.dart';
import '../../shared/params/create_update_event_param.dart';
import '../model/daily_tracker_event_model.dart';

class EventRepositoryImpl implements EventsRepository {

  final BaseService _baseService;

  EventRepositoryImpl(this._baseService);

  @override
  Future<List<EventEntity>> fetchEventsBasedOnProfile(String accountId, String id) async {
    var events = <EventEntity>[];

    var response = await _baseService.makeRequest(url: '${Urls.events}/$accountId/$id.json');
    if(response != null) {
      events = response.map<EventEntity>((json) => DailyTrackerEventModel.fromJson(json).toEntity()).toList();
    }
    return events;
  }

  @override
  Future<bool> updateOrCreateEvent(CreateUpdateEventParams params) async {
    var body = {
      params.profileId : params.events.map((e) => e.toJson()).toList()
  };

    var response = await _baseService.makeRequest(url: '${Urls.events}/${params.accountId}.json', body: body, method: RequestType.patch);
    if(response != null) {
      return true;
    }
    return false;
  }

}