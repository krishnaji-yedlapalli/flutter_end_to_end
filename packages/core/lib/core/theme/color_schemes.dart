import 'package:app_core/core/environment/environment.dart';
import 'package:flutter/material.dart';

import 'constants/app_colors.dart';

class AppColorSchemes {
  static ColorScheme lightColorScheme() {
    return ColorScheme.fromSeed(
      seedColor: Environment().configuration.seedColor,
      background: AppColors.surface,
    );
  }

  static ColorScheme darkColorScheme() {
    return ColorScheme.fromSeed(
      seedColor: Environment().configuration.seedColor,
      brightness: Brightness.dark,
    );
  }
}
