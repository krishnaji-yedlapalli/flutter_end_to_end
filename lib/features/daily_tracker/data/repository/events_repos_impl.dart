
import 'package:sample_latest/core/data/base_service.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';

import '../../domain/repository/events_repository.dart';

class EventRepositoryImpl implements EventsRepository {

  final BaseService _baseService;

  EventRepositoryImpl(this._baseService);

  @override
  Future<List<EventEntity>> fetchEventsBasedOnProfile(String accountId, String id) {
    // TODO: implement fetchEventsBasedOnProfile
    throw UnimplementedError();
  }

}