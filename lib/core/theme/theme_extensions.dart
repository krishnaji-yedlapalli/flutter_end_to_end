import 'dart:ui';

import 'package:flutter/material.dart';

class ResponsiveThemeExtension extends ThemeExtension<ResponsiveThemeExtension> {
  final double displayScale;
  final double headlineScale;
  final double bodyScale;

  ResponsiveThemeExtension({
    required this.displayScale,
    required this.headlineScale,
    required this.bodyScale,
  });

  @override
  ResponsiveThemeExtension copyWith({
    double? displayScale,
    double? headlineScale,
    double? bodyScale,
  }) {
    return ResponsiveThemeExtension(
      displayScale: displayScale ?? this.displayScale,
      headlineScale: headlineScale ?? this.headlineScale,
      bodyScale: bodyScale ?? this.bodyScale,
    );
  }

  @override
  ThemeExtension<ResponsiveThemeExtension> lerp(
      ThemeExtension<ResponsiveThemeExtension>? other,
      double t,
      ) {
    if (other is! ResponsiveThemeExtension) return this;

    return ResponsiveThemeExtension(
      displayScale: lerpDouble(displayScale, other.displayScale, t)!,
      headlineScale: lerpDouble(headlineScale, other.headlineScale, t)!,
      bodyScale: lerpDouble(bodyScale, other.bodyScale, t)!,
    );
  }

  static ResponsiveThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<ResponsiveThemeExtension>()!;
  }
}