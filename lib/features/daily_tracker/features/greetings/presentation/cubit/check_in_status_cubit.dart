
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';

import '../../../../../../core/mixins/date_formats.dart';
import '../../../../../../core/mixins/helper_methods.dart';
import '../../../../../../core/utils/enums_type_def.dart';
import '../../../../domain/usecases/check_in_status_useCase.dart';
import '../../../../domain/usecases/check_in_usecase.dart';
import '../../../events/presentation/cubit/events_cubit.dart';

part 'check_in_status_state.dart';

class CheckInStatusCubit extends Cubit<CheckInStatusState> with HelperMethods, DateFormats {

  CheckInStatusCubit(this.statusUseCase, this.eventsCubit, this.performUserCheckInUseCase) : super(const CheckInStatusLoading());

  final CheckInStatusUseCase statusUseCase;

  final PerformUserCheckInUseCase performUserCheckInUseCase;

  final EventsCubit eventsCubit;

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

    if(eventsCubit.state is EventsStateLoaded){
      var eventsState = eventsCubit.state as EventsStateLoaded;
      emit(CheckInStatusWithChecked(eventsState.events));
    }else{
     var res = await eventsCubit.loadEventsBasedOnTheUser();
    }

    var status = performUserCheckInUseCase.call();



      // var body = {
      //   currentDateInFormatted : {
      //     'isChecked' : true,
      //     'events' : todayEvents.map((e)=> e.toJson()).toList()
      //   }
      // };
      // emit(DailyStatusTrackerCheckInStatus(todayEvents, getTimeOfDay(), true, DailyStatusTrackerLoadedType.greeting));
      // bool status = await repository.checkInTheUser(body);
  }

}