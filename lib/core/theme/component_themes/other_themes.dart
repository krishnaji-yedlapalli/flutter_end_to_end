import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class OtherThemes {
  static IconThemeData iconTheme() {
    return const IconThemeData(
      color: AppColors.orange,
      fill: 0.0,
      opacity: 1.0,
      weight: 100,
      opticalSize: 20,
      grade: 0,
    );
  }

  static DialogTheme dialogTheme() {
    return const DialogTheme(
      iconColor: AppColors.orange,
    );
  }

  static SnackBarThemeData snackBarTheme(BuildContext context) {
    return SnackBarThemeData(
      backgroundColor: AppColors.black,
      contentTextStyle: Theme.of(context)
          .textTheme
          .titleMedium
          ?.apply(color: AppColors.secondary),
    );
  }

  static MaterialBannerThemeData bannerTheme(BuildContext context) {
    return MaterialBannerThemeData(
      backgroundColor: AppColors.error,
      contentTextStyle: Theme.of(context)
          .textTheme
          .titleMedium
          ?.apply(color: AppColors.secondary),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      leadingPadding: const EdgeInsets.all(0),
      elevation: 5,
    );
  }

  static DropdownMenuThemeData dropdownMenuTheme() {
    return const DropdownMenuThemeData(
      textStyle: TextStyle(fontWeight: FontWeight.w100),
    );
  }
}
