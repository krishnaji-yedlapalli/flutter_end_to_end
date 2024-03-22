import 'package:sample_latest/services/db/offline_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbConfigurationsByDev {

  static final DbConfigurationsByDev _singleton = DbConfigurationsByDev._internal();

  factory DbConfigurationsByDev() {
    return _singleton;
  }

  DbConfigurationsByDev._internal();


  static bool storeOnlyIfOffline = false;

  static bool storeInBothOfflineAndOnline = false;

  static bool dumpOfflineData = false;

  bool get storeData => storeOnlyIfOffline || storeInBothOfflineAndOnline || dumpOfflineData;

  bool get deleteOfflineDataOnceSuccess => storeOnlyIfOffline && !storeInBothOfflineAndOnline && !dumpOfflineData;

  Future<void> loadSavedData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    storeOnlyIfOffline = prefs.getBool('storeOnlyIfOffline') ?? false;
    storeInBothOfflineAndOnline = prefs.getBool('storeInBothOfflineAndOnline') ?? false;
    dumpOfflineData = prefs.getBool('dumpOfflineData') ?? false;
  }

  Future<void> saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('storeOnlyIfOffline', storeOnlyIfOffline);
    prefs.setBool('storeInBothOfflineAndOnline', storeInBothOfflineAndOnline);
    prefs.setBool('dumpOfflineData', dumpOfflineData);

    if(dumpOfflineData){
      OfflineHandler().dumpOfflineData();
    }
  }

}
