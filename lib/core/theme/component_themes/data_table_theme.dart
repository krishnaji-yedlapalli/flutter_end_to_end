import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class DataTableThemes {
  static DataTableThemeData dataTableTheme() {
    return DataTableThemeData(
      decoration: BoxDecoration(
        color: AppColors.greyWithOpacity,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      dataRowColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return AppColors.primary;
        } else {
          return AppColors.secondary;
        }
      }),
      headingTextStyle: GoogleFonts.aBeeZee(
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      dataTextStyle: GoogleFonts.abhayaLibre(
        color: AppColors.black,
      ),
      headingRowColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return AppColors.primary;
        } else {
          return AppColors.blueAccentWithOpacity;
        }
      }),
    );
  }
}
