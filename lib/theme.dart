import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData lightThemeData(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, background: Colors.white ?? Colors.green.shade50) ?? ColorScheme(brightness: Brightness.light, primary: Colors.green, primaryContainer: Colors.green, secondary: Colors.white, secondaryContainer: Colors.white, background: Colors.white, surface: Colors.green, onBackground: Colors.white, onSurface: Colors.white, onError: Colors.white, onPrimary: Colors.white, onSecondary: Colors.white, error: Colors.red.shade400),

      hoverColor: Colors.green.shade200,

      dividerColor: Colors.purple,

      /// Icon theme
      iconTheme: const IconThemeData(
          color: Colors.orange,
          fill: 0.0,
          opacity: 1.0,
          // size: 40,
          weight: 100,
          opticalSize: 20,

          /// Optical sizes range from 20dp to 48dp. we can maintain
          /// the stroke width common while resizing or on increase of the icon size
          grade: 0 // (For light and dart themes) To make strokes heavier and more emphasized, use positive value grade, such as when representing an active icon state.
          ),

      /// Card Theme
      cardTheme: CardTheme(color: Colors.white ?? Colors.green.shade50, margin: EdgeInsets.all(16), shadowColor: Colors.greenAccent, elevation: 5, surfaceTintColor: Colors.white),

      /// Text Theme data
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.nunito(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.kanit(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        titleSmall: GoogleFonts.kanit(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyMedium: GoogleFonts.dmSans(
          color: Colors.black,
        ),
      ),

      appBarTheme: const AppBarTheme(color: Colors.green, shadowColor: Colors.red, elevation: 5, foregroundColor: Colors.white),

      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              elevation: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return 5.0;
                } else {
                  return 3.0;
                }
              }),
              backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.white;
                } else {
                  return Colors.green;
                }
              }),
              shadowColor: MaterialStateProperty.all<Color>(Colors.lightGreenAccent),
              textStyle: MaterialStateProperty.all(GoogleFonts.prompt(fontWeight: FontWeight.w600)),
              foregroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                var style = GoogleFonts.prompt(fontWeight: FontWeight.w600, color: Colors.white);
                if (states.contains(MaterialState.hovered)) {
                  return Colors.green;
                } else {
                  return Colors.white;
                }
              }))),

      navigationRailTheme: NavigationRailThemeData(
        elevation: 5,
        useIndicator: true,
        indicatorColor: Colors.orange.shade100,
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        // labelType: NavigationRailLabelType.selected,
        selectedIconTheme: IconThemeData(
          color: Colors.orange,
          weight: 100,
        ),
        selectedLabelTextStyle: GoogleFonts.robotoSlab(color: Colors.orange.shade500, fontWeight: FontWeight.bold),
        unselectedLabelTextStyle: GoogleFonts.robotoSlab(color: Colors.green.shade500),
      ),

      useMaterial3: true,
    );
  }

  static ThemeData darkThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color(0X5E1BC2),
      // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    );
  }
}
