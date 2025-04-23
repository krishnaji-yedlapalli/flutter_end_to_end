import 'package:flutter/material.dart';

class ScreenBreakPoints {
  static const mobileBreakPoint = 600.0;

  static const tabletBreakPoint = 900.0;

  static const desktopBreakPoint = 1024.0;

  static bool isMobile(Size size) => size.width < mobileBreakPoint;

  static bool isTablet(Size size) =>
      size.width >= mobileBreakPoint && size.width < desktopBreakPoint;

  static bool isDesktop(Size size) => size.width >= desktopBreakPoint;
}
