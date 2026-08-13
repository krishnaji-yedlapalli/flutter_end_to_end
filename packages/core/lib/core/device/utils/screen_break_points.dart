import 'package:app_core/core/constants/responsive_constants.dart';
import 'package:flutter/material.dart';

class ScreenBreakPoints {
  static const mobileBreakPoint = ResponsiveConstants.mobileMaxWidth;

  static const tabletBreakPoint = ResponsiveConstants.mobileLandscapeMaxWidth;

  static const desktopBreakPoint = ResponsiveConstants.tabletMaxWidth;

  static bool isMobile(Size size) => size.width < mobileBreakPoint;

  static bool isTablet(Size size) =>
      size.width >= mobileBreakPoint && size.width < desktopBreakPoint;

  static bool isDesktop(Size size) => size.width >= desktopBreakPoint;
}
