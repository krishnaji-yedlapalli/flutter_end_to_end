import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommonProvider with ChangeNotifier {
  CommonProvider(this.themeModeType, Locale locale) : _selectedLocale = locale, _selectedOverridingLocale = locale;

  ThemeMode themeModeType = ThemeMode.system;
  Locale? _selectedLocale;
  Locale? _selectedOverridingLocale;

  void onChangeOfTheme() {
    themeModeType = isLightTheme ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void updateThemeData(ThemeMode mode) {
    themeModeType = mode;
    notifyListeners();
  }

  void onChangeOfLanguage(Locale? locale, {bool ignoreNotify = false}) {
    if (locale != null &&
        locale.languageCode != _selectedLocale?.languageCode) {
      Locale filteredLocale = AppLocalizations.supportedLocales.firstWhere(
          (existingLocale) =>
              locale.languageCode == existingLocale.languageCode,
          orElse: () => AppLocalizations.supportedLocales.first);
      _selectedLocale = filteredLocale;
      if (!ignoreNotify){
        notifyListeners();
      } else{
        onChangeOfOverrideLanguage(filteredLocale, ignoreNotify: ignoreNotify);
      }
    }
  }

  void onChangeOfOverrideLanguage(Locale? locale, {bool ignoreNotify = false}) {
    if (locale != null &&
        locale.languageCode != _selectedOverridingLocale?.languageCode) {
      Locale filteredLocale = AppLocalizations.supportedLocales.firstWhere(
          (existingLocale) =>
              locale.languageCode == existingLocale.languageCode,
          orElse: () => AppLocalizations.supportedLocales.first);
      _selectedOverridingLocale = filteredLocale;
      if (!ignoreNotify) notifyListeners();
    }
  }

  Locale? get locale => _selectedLocale;

  Locale? get overrideLocale => _selectedOverridingLocale;

  bool get isLightTheme =>
      themeModeType == ThemeMode.light || themeModeType == ThemeMode.system;
}
