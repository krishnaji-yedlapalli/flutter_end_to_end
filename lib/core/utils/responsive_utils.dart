import 'package:flutter/material.dart';
import '../constants/theme_constants.dart';

class ResponsiveUtils {
  static double getScaleFactor(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Progressive scaling based on screen size
    if (screenWidth <= ThemeConstants.mobileBreakpoint) {
      // Mobile devices
      return (screenWidth / ThemeConstants.baseWidth)
          .clamp(ThemeConstants.minScaleFactor, 1.0);
    } else if (screenWidth <= ThemeConstants.tabletBreakpoint) {
      // Tablets
      double scale = 1.0 + (((screenWidth - ThemeConstants.mobileBreakpoint) /
          (ThemeConstants.tabletBreakpoint - ThemeConstants.mobileBreakpoint)) * 0.1);
      return scale.clamp(1.0, 1.1);
    } else {
      // Larger screens
      return ThemeConstants.maxScaleFactor; // Fixed scale for larger screens
    }
  }

  static double getResponsiveFontSize(double baseSize, BuildContext context) {
    double scaleFactor = getScaleFactor(context);
    return baseSize * scaleFactor;
  }
}