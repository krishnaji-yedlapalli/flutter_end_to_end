import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_core/core/environment/environment.dart';

import '../extensions/responsive_theme_extension.dart';
import 'color_schemes.dart';
import 'component_themes/app_bar_theme.dart';
import 'component_themes/button_themes.dart';
import 'component_themes/card_theme.dart';
import 'component_themes/data_table_theme.dart';
import 'component_themes/navigation_theme.dart';
import 'component_themes/other_themes.dart';
import 'constants/app_colors.dart';
import 'text_themes.dart';

class LightTheme {
  static ThemeData themeData(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double baseScale = screenWidth / 375;
    baseScale = baseScale.clamp(0.8, 1.4);

    return ThemeData(
      brightness: Brightness.light,
      fontFamily: GoogleFonts.openSans().fontFamily,
      colorScheme: AppColorSchemes.lightColorScheme(),
      hoverColor:
          Environment().configuration.hoverColor ?? AppColors.lightHover,
      dividerColor: AppColors.purple,

      // Component themes
      iconTheme: OtherThemes.iconTheme(),
      cardTheme: CardThemes.lightCardTheme(),
      textTheme: AppTextThemes.getResponsiveTextTheme(context),
      appBarTheme: AppBarThemes.lightAppBarTheme(),
      elevatedButtonTheme: ButtonThemes.elevatedButtonTheme(),
      textButtonTheme: ButtonThemes.textButtonTheme(),
      navigationRailTheme: NavigationThemes.navigationRailTheme(),
      dialogTheme: OtherThemes.dialogTheme(),
      snackBarTheme: OtherThemes.snackBarTheme(context),
      bannerTheme: OtherThemes.bannerTheme(context),
      dataTableTheme: DataTableThemes.dataTableTheme(),
      dropdownMenuTheme: OtherThemes.dropdownMenuTheme(),

      extensions: [
        ResponsiveThemeExtension(
          displayScale: baseScale * 1.2,
          headlineScale: baseScale * 1.1,
          bodyScale: baseScale,
        ),
      ],
      useMaterial3: true,
    );
  }
}
