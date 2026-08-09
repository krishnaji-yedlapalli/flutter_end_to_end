import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'component_themes/app_bar_theme.dart';
import 'component_themes/card_theme.dart';
import 'component_themes/other_themes.dart';

class DarkTheme {
  static ThemeData themeData() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: AppColorSchemes.darkColorScheme(),
      cardTheme: CardThemes.darkCardTheme(),
      appBarTheme: AppBarThemes.darkAppBarTheme(),
      iconTheme: OtherThemes.iconTheme(),
      useMaterial3: true,
    );
  }
}
