

import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:sample_latest/features/daily_tracker/shared/models/profile_executed_task.dart';

import '../../../../analytics_exception_handler/exception_handler.dart';
import '../../data/repository/events_repos_impl.dart';
import '../../shared/params/today_event_update_param.dart';
import '../../shared/params/user_check_in_params.dart';
import '../entities/checkIn_status_entity.dart';
import '../entities/event_entity.dart';
import '../repository/check_in_status_repo.dart';
import '../repository/events_repository.dart';

class UpdateTodayEventUseCase {

  UpdateTodayEventUseCase(this._eventRepositoryImpl, this.profileExecutedTask);

  final EventsRepository _eventRepositoryImpl;

  final ProfileExecutedTask profileExecutedTask;

  Future<Either<ErrorDetails, bool>> call(String date, EventEntity event) async {
    try{
      var params = TodayEventParam(profileExecutedTask.profileId, event, date);
      var index = profileExecutedTask.todayEvents.indexWhere((e)=> e.id == event.id);
      if(index != -1){
        profileExecutedTask.todayEvents[index] = event;
      }
      var status = await _eventRepositoryImpl.updateTodayEvents(params);
      return Right(status);
    }catch(e,s){
      return  Left(ExceptionHandler().handleException(e, s));
    }
  }
}