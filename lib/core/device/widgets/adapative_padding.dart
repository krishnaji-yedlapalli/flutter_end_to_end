
import 'package:flutter/material.dart';
import 'package:sample_latest/core/device/utils/screen_break_points.dart';

class AdaptivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AdaptivePadding({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? _getPadding(context),
      child: child,
    );
  }

  EdgeInsets _getPadding(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < ScreenBreakPoints.mobileBreakPoint) {
      return const EdgeInsets.all(8);
    } else if (screenWidth > ScreenBreakPoints.mobileBreakPoint && screenWidth < ScreenBreakPoints.desktopBreakPoint) {
      return const EdgeInsets.all(16);
    } else {
      return const EdgeInsets.all(20);
    }
  }
}