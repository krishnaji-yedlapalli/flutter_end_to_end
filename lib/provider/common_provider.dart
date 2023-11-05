
import 'package:flutter/material.dart';

class CommonProvider with ChangeNotifier {

  ThemeMode themeModeType = ThemeMode.system;

  void onChangeOfTheme() {
    themeModeType = isLightTheme ?  ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  bool get isLightTheme => themeModeType == ThemeMode.light || themeModeType == ThemeMode.system;

}