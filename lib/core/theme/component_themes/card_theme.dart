import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CardThemes {
  static CardThemeData lightCardTheme() {
    return CardThemeData(
      color: AppColors.lightBackground,
      margin: const EdgeInsets.all(16),
      shadowColor: Colors.greenAccent,
      elevation: 5,
      surfaceTintColor: AppColors.secondary,
    );
  }

  static CardThemeData darkCardTheme() {
    return const CardThemeData(
      margin: EdgeInsets.all(16),
      elevation: 5,
    );
  }
}
