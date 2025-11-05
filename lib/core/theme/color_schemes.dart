import 'package:flutter/material.dart';
import 'package:sample_latest/core/environment/environment.dart';
import 'constants/app_colors.dart';

class AppColorSchemes {
  static ColorScheme lightColorScheme() {
    return ColorScheme.fromSeed(
          seedColor: Environment().configuration.seedColor,
          background: AppColors.surface,
        ) ??
        ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          primaryContainer: AppColors.primary,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondary,
          surface: AppColors.primary,
          onSurface: AppColors.secondary,
          onError: AppColors.secondary,
          onPrimary: AppColors.secondary,
          onSecondary: AppColors.secondary,
          error: AppColors.errorShade,
        );
  }

  static ColorScheme darkColorScheme() {
    return ColorScheme.fromSeed(
      seedColor: Environment().configuration.seedColor,
      brightness: Brightness.dark,
    );
  }
}
