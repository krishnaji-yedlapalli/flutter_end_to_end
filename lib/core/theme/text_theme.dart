import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_latest/core/utils/responsive_utils.dart';

class AppTextTheme {
  static TextTheme getResponsiveTextTheme(BuildContext context) {

    // Define your base sizes
    double scaleFactor = ResponsiveUtils.getScaleFactor(context); // Using iPhone X width as base

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: (Theme.of(context).textTheme.displayLarge?.fontSize ?? 32) * scaleFactor,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize ?? 28) * scaleFactor,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        fontSize: (Theme.of(context).textTheme.displaySmall?.fontSize ?? 24) * scaleFactor,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        fontSize: (Theme.of(context).textTheme.headlineLarge?.fontSize ?? 22) * scaleFactor,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        fontSize: (Theme.of(context).textTheme.headlineMedium?.fontSize ?? 20) * scaleFactor,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontSize: (Theme.of(context).textTheme.headlineSmall?.fontSize ?? 18) * scaleFactor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.nunito(
        fontSize: (Theme.of(context).textTheme.titleLarge?.fontSize ?? 16) * scaleFactor,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: GoogleFonts.kanit(
        fontSize: (Theme.of(context).textTheme.titleMedium?.fontSize ?? 14) * scaleFactor,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleSmall: GoogleFonts.kanit(
        fontSize: (Theme.of(context).textTheme.titleSmall?.fontSize ?? 12) * scaleFactor,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16) * scaleFactor,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) * scaleFactor,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        fontSize: (Theme.of(context).textTheme.bodySmall?.fontSize ?? 12) * scaleFactor,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  static ThemeData getTheme(BuildContext context) {
    return ThemeData(
      textTheme: getResponsiveTextTheme(context),
      // Add other theme configurations here
    );
  }
}
