import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/features/daily_tracker/data/model/daily_tracker_event_model.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/repository/events_repository.dart';
import 'package:sample_latest/features/daily_tracker/shared/models/profiles_executed_task.dart';

import '../../../../analytics_exception_handler/exception_handler.dart';
import '../../../../core/data/utils/service_enums_typedef.dart';
import '../../shared/models/profile_executed_task.dart';

class DeleteEventUseCase {
  final ProfileExecutedTask _profileExecutedTask;

  final EventsRepository _eventsRepository;

  DeleteEventUseCase(this._profileExecutedTask, this._eventsRepository);

  Future<Either<List<EventEntity>, ErrorDetails>> call(String eventId) async {
    try {
      var res = await _eventsRepository.deleteEvent(
          _profileExecutedTask.profileId, eventId);

      return Left(deleteEventFromList(eventId));
    } catch (e, s) {
      return Right(ExceptionHandler().handleException(e, s));
    }
  }

  List<EventEntity> deleteEventFromList(String eventId) {
    _profileExecutedTask.userEvents.removeWhere((e) => eventId == e.id);
    return List.from(_profileExecutedTask.userEvents
        .map((e) => DailyTrackerEventModel.fromJson(e.toJson()).toEntity())
        .toList());
  }
}
