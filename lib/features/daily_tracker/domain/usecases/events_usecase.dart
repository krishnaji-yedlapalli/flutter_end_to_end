import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/repository/events_repository.dart';

import '../../../../analytics_exception_handler/exception_handler.dart';
import '../../../../core/data/utils/service_enums_typedef.dart';
import '../../shared/models/profile_executed_task.dart';
import '../../shared/utils/event_sorter_converter.dart';

class EventsUseCase {
  EventsUseCase(this._repository, this._profileExecutedTask);

  final EventsRepository _repository;

  final ProfileExecutedTask _profileExecutedTask;

  Future<Either<ErrorDetails, List<EventEntity>>> call() async {
    try {
      var events = await _repository
          .fetchEventsBasedOnProfile(_profileExecutedTask.profileId);

      var todayEvents = EventSortHelper().getTodaySortedEvent(events);
      _profileExecutedTask.userEvents = todayEvents;
      return Right(todayEvents);
    } catch (e, s) {
      return Left(ExceptionHandler().handleException(e, s));
    }
  }
}
