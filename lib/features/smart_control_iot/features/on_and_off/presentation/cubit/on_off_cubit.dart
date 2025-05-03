
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/on_off_usecase.dart';
import 'on_off_state.dart';

class OnOffCubit extends Cubit<OnOffState> {
  OnOffCubit(this._onOffUsecase)
      : super(OnOffStateLoading());

  final OnOffUsecase _onOffUsecase;


  Future<void> loadStatus() async {
    var status = await _onOffUsecase.status();
    emit(CurrentOnOffState(status));
  }

  Future<void> on() async {
    emit(OnOffStateLoading());
    var status = await _onOffUsecase.on();
    emit(CurrentOnOffState(status));
  }

  Future<void> off() async {
    emit(OnOffStateLoading());
    var status = await _onOffUsecase.off();

    emit(CurrentOnOffState(status));
  }
}