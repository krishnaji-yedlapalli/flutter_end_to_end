
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/mixins/date_formats.dart';
import 'package:sample_latest/mixins/helper_methods.dart';
import 'package:sample_latest/models/daily_tracker/daily_tracker_event_model.dart';
import 'package:sample_latest/services/repository/daily_tracker_repository.dart';
import 'package:sample_latest/utils/enums_type_def.dart';

part 'daily_status_tracker_state.dart';

class DailyTrackerStatusBloc extends Cubit<DailyStatusTrackerState> with HelperMethods, DateFormats{

  final DailyTrackerRepository repository;

  DailyTrackerStatusBloc(this.repository)
      : super(const DailyStatusTrackerInitial(DailyStatusTrackerLoadedType.greeting));


  void getCheckInStatus() async {
    try{
      bool status = await repository.isCheckedIn(currentDateInFormatted);
      emit(DailyStatusTrackerCheckInStatus(getTimeOfDay(), status, DailyStatusTrackerLoadedType.greeting));
    }catch(e,s){

    }
  }

  void checkIn() async {
    try{
      var body = {
        currentDateInFormatted : true
      };
      bool status = await repository.checkInTheUser(body);
      emit(DailyStatusTrackerCheckInStatus(getTimeOfDay(), status, DailyStatusTrackerLoadedType.greeting));
    }catch(e,s){

    }
  }

  void createOrUpdateEvent(DailyTrackerEventModel event) async {
    try{
      var createdEvent = await repository.createOrEditEvent(event);
      // emit(DailyStatusTrackerCheckInStatus(getTimeOfDay(), createdEvent, DailyStatusTrackerLoadedType.greeting));
    }catch(e,s){

    }
  }
}