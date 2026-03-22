import 'package:flutter/material.dart';
import 'package:sample_latest/core/environment/environment.dart';
import '../constants/app_colors.dart';

class AppBarThemes {
  static AppBarTheme lightAppBarTheme() {
    return AppBarTheme(
      backgroundColor: Environment().configuration.seedColor,
      shadowColor: AppColors.error,
      elevation: 5,
      foregroundColor: AppColors.secondary,
    );
  }

  static AppBarTheme darkAppBarTheme() {
    return const AppBarTheme(
      elevation: 5,
    );
  }
}
