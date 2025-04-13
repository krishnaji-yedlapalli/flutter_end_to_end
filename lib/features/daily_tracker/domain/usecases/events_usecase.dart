
import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/repository/events_repository.dart';

import '../../../../analytics_exception_handler/exception_handler.dart';
import '../../../../core/data/utils/service_enums_typedef.dart';

class EventsUseCase {

  EventsUseCase(this._repository);

  final EventsRepository _repository;

  Future<Either<ErrorDetails ,List<EventEntity>>> call(String id) async {
    try {
      var res = await _repository.fetchEventsBasedOnProfile(
          'u94jTpJvOXbBVmO7rLTPf8Ew2zx2', id);
      return Right(res);
    }catch(e,s){
      return  Left(ExceptionHandler().handleException(e, s));
    }
  }
}