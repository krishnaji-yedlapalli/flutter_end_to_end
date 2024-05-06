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

  static int howLongDataShouldPersist = 2;

  static bool dumpOfflineData = false;

  static DateTime? lastDeletedOutDataDate;

  static bool get storeData => storeOnlyIfOffline || storeInBothOfflineAndOnline || dumpOfflineData;

  static bool get deleteOfflineDataOnceSuccess => storeOnlyIfOffline && !storeInBothOfflineAndOnline && !dumpOfflineData;

  static bool get isOutDatedDataNeedsToBeDeleted => storeInBothOfflineAndOnline || dumpOfflineData;

  static set (DateTime dateTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastDeletedOutDataDate', dateTime.toString());
  }

  Future<void> loadSavedData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    storeOnlyIfOffline = prefs.getBool('storeOnlyIfOffline') ?? false;
    storeInBothOfflineAndOnline = prefs.getBool('storeInBothOfflineAndOnline') ?? false;
    dumpOfflineData = prefs.getBool('dumpOfflineData') ?? false;
    lastDeletedOutDataDate = prefs.containsKey('lastDeletedOutDataDate') ? DateTime.parse(prefs.getString('lastDeletedOutDataDate')!) : null;
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
