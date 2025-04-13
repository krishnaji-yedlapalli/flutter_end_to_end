
import 'package:sample_latest/features/daily_tracker/domain/entities/checkIn_status_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';

import '../../../../core/data/base_service.dart';
import '../../../../core/data/urls.dart';
import '../../domain/repository/check_in_status_repo.dart';
import '../model/daily_tracker_event_model.dart';

class CheckInStatusRepositoryImpl implements CheckInStatusRepository {


  final BaseService baseService;

  CheckInStatusRepositoryImpl(this.baseService);

  @override
  Future<CheckInStatusEntity> isCheckedIn(String date) async {
    CheckInStatusEntity checkInStatus;
    var events = <EventEntity>[];


    var response = await baseService.makeRequest(url: '${Urls.dailyCheckIns}/$date.json');
    if(response != null && response['events'] != null) {
      events = response['events'].map<EventEntity>((json) => DailyTrackerEventModel.fromJson(json).toEntity()).toList();
    }
    return CheckInStatusEntity(events: events, status: events.isNotEmpty);
  }

  @override
  Future<CheckInStatusEntity> submitUserCheckIn(String date) {
    // TODO: implement submitUserCheckIn
    throw UnimplementedError();
  }
}