import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class NavigationThemes {
  static NavigationRailThemeData navigationRailTheme() {
    return NavigationRailThemeData(
      elevation: 5,
      useIndicator: true,
      indicatorColor: AppColors.orangeShade100,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      selectedIconTheme: const IconThemeData(
        color: AppColors.orange,
        weight: 100,
      ),
      selectedLabelTextStyle: GoogleFonts.robotoSlab(
        color: AppColors.orangeShade500,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelTextStyle: GoogleFonts.robotoSlab(
        color: AppColors.greenShade500,
      ),
    );
  }
}
