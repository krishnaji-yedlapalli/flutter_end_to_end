// Main theme exports
import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

export '../extensions/responsive_theme_extension.dart';
export 'color_schemes.dart';
// Component theme exports
export 'component_themes/app_bar_theme.dart';
export 'component_themes/button_themes.dart';
export 'component_themes/card_theme.dart';
export 'component_themes/data_table_theme.dart';
export 'component_themes/navigation_theme.dart';
export 'component_themes/other_themes.dart';
export 'constants/app_colors.dart';
export 'constants/font_families.dart';
export 'dark_theme.dart';
export 'light_theme.dart';
export 'text_themes.dart';

class CustomTheme {
  static ThemeData lightThemeData(BuildContext context) {
    return LightTheme.themeData(context);
  }

  static ThemeData darkThemeData() {
    return DarkTheme.themeData();
  }
}
