import 'package:sample_latest/core/data/base_service.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';

import '../../../../core/data/urls.dart';
import '../../core/services/session_manager.dart';
import '../../domain/repository/events_repository.dart';
import '../../shared/params/create_update_event_param.dart';
import '../../shared/params/today_event_update_param.dart';
import '../model/daily_tracker_event_model.dart';

class EventRepositoryImpl implements EventsRepository {
  final BaseService _baseService;
  final SessionManager _sessionManager;

  EventRepositoryImpl(this._baseService, this._sessionManager);

  @override
  Future<List<EventEntity>> fetchEventsBasedOnProfile(String id) async {
    var events = <EventEntity>[];

    var response = await _baseService.makeRequest(
        url: '${Urls.events}/${_sessionManager.accountId}/$id.json');
    if (response != null && response is Map) {
      events = response.entries
          .map<EventEntity>(
              (json) => DailyTrackerEventModel.fromJson(json.value).toEntity())
          .toList();
    }
    return events;
  }

  @override
  Future<bool> updateOrCreateEvent(CreateUpdateEventParams params) async {
    var body = {params.event.id: params.event.toJson()};

    var response = await _baseService.makeRequest(
        url:
            '${Urls.events}/${_sessionManager.accountId}/${params.profileId}.json',
        body: body,
        method: RequestType.patch);
    if (response != null) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> updateTodayEvents(TodayEventParam params) async {
    var body = {params.event.id: params.event.toJson()};

    var response = await _baseService.makeRequest(
        url:
            '${Urls.dailyCheckIns}/${params.date}/${_sessionManager.accountId}/${params.profileId}.json',
        body: body,
        method: RequestType.patch);
    if (response != null) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteEvent(String profileId, String eventId) async {
    var response = await _baseService.makeRequest(
        url:
            '${Urls.events}/${_sessionManager.accountId}/$profileId/$eventId.json',
        method: RequestType.delete);

    if (response != null) {
      return true;
    }
    return false;
  }
}
