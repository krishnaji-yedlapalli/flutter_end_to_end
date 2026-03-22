import 'package:sample_latest/core/data/db/cubit/db_config_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbConfigRepository {
  DbConfigState _state = const DbConfigState();

  DbConfigState get state => _state;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    DateTime? lastDeleted = prefs.containsKey('lastDeletedOutDataDate')
        ? DateTime.parse(prefs.getString('lastDeletedOutDataDate')!)
        : null;

    _state = DbConfigState(
      storeOnlyIfOffline: prefs.getBool('storeOnlyIfOffline') ?? false,
      storeInBothOfflineAndOnline:
          prefs.getBool('storeInBothOfflineAndOnline') ?? false,
      howLongDataShouldPersist: prefs.getInt('howLongDataShouldPersist') ?? 2,
      dumpOfflineData: prefs.getBool('dumpOfflineData') ?? false,
      lastDeletedOutDataDate: lastDeleted,
    );
  }

  void updateState(DbConfigState newState) {
    _state = newState;
  }

  Future<bool> save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('storeOnlyIfOffline', _state.storeOnlyIfOffline);
    prefs.setBool(
        'storeInBothOfflineAndOnline', _state.storeInBothOfflineAndOnline);
    prefs.setBool('dumpOfflineData', _state.dumpOfflineData);
    prefs.setInt('howLongDataShouldPersist', _state.howLongDataShouldPersist);
    return _state.dumpOfflineData;
  }

  Future<void> persistLastDeletedDate(DateTime dateTime) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastDeletedOutDataDate', dateTime.toString());
    _state = _state.copyWith(lastDeletedOutDataDate: dateTime);
  }
}
