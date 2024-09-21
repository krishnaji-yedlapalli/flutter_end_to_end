import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_latest/environment/environment.dart';

class CustomTheme {
  static ThemeData lightThemeData(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: GoogleFonts.openSans().fontFamily,
      colorScheme: ColorScheme.fromSeed(seedColor: Environment().configuration.seedColor, background: Colors.white ?? Colors.green.shade50) ?? ColorScheme(brightness: Brightness.light, primary: Colors.green, primaryContainer: Colors.green, secondary: Colors.white, secondaryContainer: Colors.white, background: Colors.white, surface: Colors.green, onBackground: Colors.white, onSurface: Colors.white, onError: Colors.white, onPrimary: Colors.white, onSecondary: Colors.white, error: Colors.red.shade400),

      hoverColor: Environment().configuration.hoverColor ?? Colors.green.shade200,

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
      cardTheme: CardTheme(color: Colors.white ?? Colors.green.shade50, margin: const EdgeInsets.all(16), shadowColor: Colors.greenAccent, elevation: 5, surfaceTintColor: Colors.white),

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

      appBarTheme: AppBarTheme(color: Environment().configuration.seedColor, shadowColor: Colors.red, elevation: 5, foregroundColor: Colors.white),

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
                if(states.contains(WidgetState.disabled)){
                  return Colors.grey;
                }else if (states.contains(MaterialState.hovered)) {
                  return Colors.white;
                } else {
                  return Colors.green;
                }
              }),
              shadowColor: WidgetStateProperty.all<Color>(Colors.lightGreenAccent),
              textStyle: WidgetStateProperty.all(GoogleFonts.prompt(fontWeight: FontWeight.w600)),
              foregroundColor: WidgetStateProperty.resolveWith((Set<MaterialState> states) {
                 if (states.contains(WidgetState.hovered)) {
                  return Colors.green;
                } else {
                  return Colors.white;
                }
              }))),

      textButtonTheme: TextButtonThemeData(style: ButtonStyle(shadowColor: MaterialStateProperty.all<Color>(Colors.lightGreenAccent), foregroundColor: MaterialStateProperty.all(Colors.white))),

      navigationRailTheme: NavigationRailThemeData(
        elevation: 5,
        useIndicator: true,
        indicatorColor: Colors.orange.shade100,
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        // labelType: NavigationRailLabelType.selected,
        selectedIconTheme: const IconThemeData(
          color: Colors.orange,
          weight: 100,
        ),
        selectedLabelTextStyle: GoogleFonts.robotoSlab(color: Colors.orange.shade500, fontWeight: FontWeight.bold),
        unselectedLabelTextStyle: GoogleFonts.robotoSlab(color: Colors.green.shade500),
      ),

      dialogTheme: const DialogTheme(iconColor: Colors.orange),

      snackBarTheme: SnackBarThemeData(backgroundColor: Colors.black, contentTextStyle: Theme.of(context).textTheme.titleMedium?.apply(color: Colors.white)),

      bannerTheme: MaterialBannerThemeData(backgroundColor: Colors.red, contentTextStyle: Theme.of(context).textTheme.titleMedium?.apply(color: Colors.white), padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8), leadingPadding: const EdgeInsets.all(0), elevation: 5),

      dataTableTheme: DataTableThemeData(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          dataRowColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.green;
              } else {
                return Colors.white;
              }
            },
          ),
          headingTextStyle: GoogleFonts.aBeeZee(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          dataTextStyle: GoogleFonts.abhayaLibre(
            color: Colors.black,
          ),
          headingRowColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.green;
            } else {
              return Colors.blueAccent.withOpacity(0.5);
            }
          },
          ),
      ),

      dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: TextStyle(fontWeight: FontWeight.w100)
      ),

      useMaterial3: true,
    );
  }

  static ThemeData darkThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      cardTheme: const CardTheme(margin: EdgeInsets.all(16), elevation: 5),
      appBarTheme: const AppBarTheme(elevation: 5),

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
      // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    );
  }
}
