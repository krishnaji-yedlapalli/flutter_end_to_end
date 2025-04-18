
import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/core/mixins/date_formats.dart';
import 'package:sample_latest/core/mixins/helper_methods.dart';
import 'package:sample_latest/features/daily_tracker/data/model/action_event.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/repository/check_in_status_repo.dart';

import '../../../../analytics_exception_handler/exception_handler.dart';
import '../../../../core/data/utils/service_enums_typedef.dart';
import '../../shared/models/profile_executed_task.dart';
import '../../shared/params/user_check_in_params.dart';

class PerformUserCheckInUseCase with DateFormats{

  PerformUserCheckInUseCase(this._checkInStatusRepository, this.profileExecutedTask);

  final CheckInStatusRepository _checkInStatusRepository;

  final ProfileExecutedTask profileExecutedTask;

  Future<Either<ErrorDetails, bool>> call(List<EventEntity> events) async {
    try {
      /// If events is Empty
      if(events.isEmpty){
        events.add(EventEntity(id: "63a5d8007d04111490757feeb082f05f",
            eventType: "everyday",
            title: "Gym",
            description: "ready",
            createdDate: 1724945419249,
            selectedDateTime: 1724869800000,
            actionCheckList: [
              ActionEventModel('chec', true)
            ]));
      }

      var params = UserCheckInParams(profileExecutedTask.profileId, events, currentDateInFormatted);
      var res = await _checkInStatusRepository.submitUserCheckIn(params);
      return const Right(true);
    }catch(e,s){
      return  Left(ExceptionHandler().handleException(e, s));
    }
  }
}