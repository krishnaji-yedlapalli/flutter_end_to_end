
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/usecases/update_today_event_useCase.dart';

import '../../../../../../core/mixins/date_formats.dart';
import '../../../../../../core/mixins/helper_methods.dart';
import '../../../../../../core/utils/enums_type_def.dart';
import '../../../../domain/usecases/check_in_status_useCase.dart';
import '../../../../domain/usecases/check_in_usecase.dart';
import '../../../../domain/usecases/events_usecase.dart';

part 'check_in_status_state.dart';

class CheckInStatusCubit extends Cubit<CheckInStatusState> with HelperMethods, DateFormats {

  CheckInStatusCubit(this.statusUseCase, this.performUserCheckInUseCase, this.eventsUseCase) : super(const CheckInStatusLoading());

  final CheckInStatusUseCase statusUseCase;

  final PerformUserCheckInUseCase performUserCheckInUseCase;

  final EventsUseCase eventsUseCase;

  void getCheckInStatus() async {

      emit(const CheckInStatusLoading());

      var checkInStatus = await statusUseCase.call(currentDateInFormatted);

      switch (checkInStatus) {
        case Right(value: final checkInDetails):
          if (checkInDetails.status) {
            emit(CheckInStatusWithChecked(checkInDetails.events));
          } else {
            emit(CheckInStatusNotYetChecked(getTimeOfDay()));
          }
        case Left(value: final failure):
          // emit(CheckInStatusFailed(failure.message));
      }
  }

  Future<void> checkIn() async {
     var res = await eventsUseCase.call();

     res.fold((error){
     print('error');
     }, (events) {
       emit(CheckInStatusWithChecked(events));
       var status = performUserCheckInUseCase.call(events);
     });
  }


  void updateEvents(List<EventEntity> events) async {
    var list = events.map<EventEntity>((e)=> EventEntity.fromJson(e.toJson())).toList();
    emit(CheckInStatusWithChecked(list));
  }
}