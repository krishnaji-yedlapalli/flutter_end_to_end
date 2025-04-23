import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:sample_latest/features/daily_tracker/core/services/session_manager.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/checkIn_status_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';

import '../../../../core/data/base_service.dart';
import '../../../../core/data/urls.dart';
import '../../domain/repository/check_in_status_repo.dart';
import '../../shared/params/user_check_in_params.dart';
import '../model/daily_tracker_event_model.dart';

class CheckInStatusRepositoryImpl implements CheckInStatusRepository {
  final BaseService baseService;
  final SessionManager _sessionManager;

  CheckInStatusRepositoryImpl(this.baseService, this._sessionManager);

  @override
  Future<CheckInStatusEntity> isCheckedIn(UserCheckInParams params) async {
    var events = <EventEntity>[];

    var response = await baseService.makeRequest(
        url:
            '${Urls.dailyCheckIns}/${params.date}/${_sessionManager.accountId}/${params.profileId}.json');
    if (response != null && response is Map) {
      events = response.entries
          .map<EventEntity>(
              (json) => DailyTrackerEventModel.fromJson(json.value).toEntity())
          .toList();
      return CheckInStatusEntity(events: events, status: true);
    } else {
      return CheckInStatusEntity(events: events, status: false);
    }
  }

  @override
  Future<bool> submitUserCheckIn(UserCheckInParams params) async {
    var body = {
      params.profileId: Map.fromEntries(
        params.events.map((e) => MapEntry(e.id!, e.toJson())),
      )
    };

    var response = await baseService.makeRequest(
        url:
            '${Urls.dailyCheckIns}/${params.date}/${_sessionManager.accountId}.json',
        body: body,
        method: RequestType.patch);
    if (response != null) {
      return true;
    }
    return false;
  }
}
