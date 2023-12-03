
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommonProvider with ChangeNotifier {

  CommonProvider(this.themeModeType) ;

  ThemeMode themeModeType = ThemeMode.system;
  Locale? _selectedLocale;

  void onChangeOfTheme() {
    themeModeType = isLightTheme ?  ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void updateThemeData (ThemeMode mode) {
    themeModeType = mode;
    notifyListeners();
  }

  void onChangeOfLanguage(Locale? locale, {bool ignoreNotify = false}) {
    if(locale != null && locale.languageCode != _selectedLocale?.languageCode) {
      Locale filteredLocale = AppLocalizations.supportedLocales.firstWhere((existingLocale) => locale.languageCode == existingLocale.languageCode, orElse: () => AppLocalizations.supportedLocales.first);
      _selectedLocale = filteredLocale;
     if(!ignoreNotify) notifyListeners();
    }
  }

  Locale? get locale => _selectedLocale;

  bool get isLightTheme => themeModeType == ThemeMode.light || themeModeType == ThemeMode.system;

}