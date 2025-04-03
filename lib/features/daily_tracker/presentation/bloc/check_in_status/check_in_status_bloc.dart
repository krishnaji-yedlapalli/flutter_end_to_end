

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/checkIn_status_entity.dart';

import '../../../domain/usecases/check_in_status_useCase.dart';

part 'check_in_status_state.dart';

class CheckInStatusBloc extends Cubit<DailyCheckInStatus> {

  CheckInStatusBloc(super.initialState, this.checkInStatusUseCase);

  final CheckInStatusUseCase checkInStatusUseCase;


  void loadCheckInStatus() async {

      // var response = await checkInStatusUseCase.call();


      // emit(DailyCheckInStatusLoaded(statusEntity));





  }

}