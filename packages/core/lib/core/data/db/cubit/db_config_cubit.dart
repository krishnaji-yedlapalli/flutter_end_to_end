import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_core/core/data/db/cubit/db_config_state.dart';
import 'package:app_core/core/data/db/db_config_repository.dart';

class DbConfigCubit extends Cubit<DbConfigState> {
  final DbConfigRepository _repository;

  DbConfigCubit(this._repository) : super(_repository.state);

  void onSelection(int index, bool status) {
    late DbConfigState newState;
    switch (index) {
      case 0:
        newState = state.copyWith(storeOnlyIfOffline: status);
        break;
      case 1:
        newState = state.copyWith(
          storeOnlyIfOffline: status,
          storeInBothOfflineAndOnline: status,
        );
        break;
      case 2:
        newState = state.copyWith(
          storeOnlyIfOffline: status,
          storeInBothOfflineAndOnline: status,
          dumpOfflineData: status,
        );
        break;
      default:
        return;
    }
    _repository.updateState(newState);
    emit(newState);
  }

  void updateHowLongDataShouldPersist(int days) {
    final newState = state.copyWith(howLongDataShouldPersist: days);
    _repository.updateState(newState);
    emit(newState);
  }

  /// Returns true if dumpOfflineData is enabled (caller should trigger the dump)
  Future<bool> save() async {
    return await _repository.save();
  }
}
