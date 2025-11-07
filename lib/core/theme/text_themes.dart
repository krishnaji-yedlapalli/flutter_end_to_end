import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../device/config/device_configurations.dart';
import 'constants/app_colors.dart';

class AppTextThemes {
  static TextTheme getResponsiveTextTheme(BuildContext context) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: DeviceConfiguration.getResponsiveFontSize(32),
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: DeviceConfiguration.getResponsiveFontSize(28),
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        fontSize: DeviceConfiguration.getResponsiveFontSize(24),
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        fontSize: DeviceConfiguration.getResponsiveFontSize(22),
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        fontSize: DeviceConfiguration.getResponsiveFontSize(20),
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontSize: DeviceConfiguration.getResponsiveFontSize(18),
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.nunito(
        fontSize: DeviceConfiguration.getResponsiveFontSize(16),
        fontWeight: FontWeight.bold,
        color: AppColors.secondary,
      ),
      titleMedium: GoogleFonts.kanit(
        fontSize: DeviceConfiguration.getResponsiveFontSize(14),
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      titleSmall: GoogleFonts.kanit(
        fontSize: DeviceConfiguration.getResponsiveFontSize(12),
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: DeviceConfiguration.getResponsiveFontSize(16),
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: DeviceConfiguration.getResponsiveFontSize(14),
        fontWeight: FontWeight.normal,
        color: AppColors.black,
      ),
      bodySmall: TextStyle(
        fontSize: DeviceConfiguration.getResponsiveFontSize(12),
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
