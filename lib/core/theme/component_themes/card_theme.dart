import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CardThemes {
  static CardTheme lightCardTheme() {
    return CardTheme(
      color: AppColors.lightBackground,
      margin: const EdgeInsets.all(16),
      shadowColor: Colors.greenAccent,
      elevation: 5,
      surfaceTintColor: AppColors.secondary,
    );
  }

  static CardTheme darkCardTheme() {
    return const CardTheme(
      margin: EdgeInsets.all(16),
      elevation: 5,
    );
  }
}
