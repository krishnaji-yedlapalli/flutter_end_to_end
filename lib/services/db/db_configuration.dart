
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

}
