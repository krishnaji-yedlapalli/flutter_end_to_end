import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class ButtonThemes {
  static ElevatedButtonThemeData elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return 5.0;
          } else {
            return 3.0;
          }
        }),
        backgroundColor:
            WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.grey;
          } else if (states.contains(WidgetState.hovered)) {
            return AppColors.secondary;
          } else {
            return AppColors.primary;
          }
        }),
        shadowColor: WidgetStateProperty.all<Color>(AppColors.lightShadow),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.prompt(fontWeight: FontWeight.w600),
        ),
        foregroundColor:
            WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.primary;
          } else {
            return AppColors.secondary;
          }
        }),
      ),
    );
  }

  static TextButtonThemeData textButtonTheme() {
    return TextButtonThemeData(
      style: ButtonStyle(
        shadowColor: WidgetStateProperty.all<Color>(AppColors.lightShadow),
        foregroundColor: WidgetStateProperty.all(AppColors.secondary),
      ),
    );
  }
}
