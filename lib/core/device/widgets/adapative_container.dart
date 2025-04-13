import 'package:flutter/material.dart';
import 'package:sample_latest/core/device/utils/screen_break_points.dart';

class AdaptiveContainer extends StatelessWidget {
  final Widget child;
  final double mobileWidth;
  final double tabletWidth;
  final double desktopWidth;
  final double? maxWidth;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;

  const AdaptiveContainer({
    Key? key,
    required this.child,
    this.mobileWidth = 1,
    this.tabletWidth = 0.7,
    this.desktopWidth = 0.5,
    this.maxWidth,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.centerLeft
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: _getWidth(context),
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? double.infinity,
          ),
          padding: padding,
          alignment: alignment,
          child: child,
        );
      },
    );
  }

  double _getWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < ScreenBreakPoints.mobileBreakPoint) {
      return screenWidth * mobileWidth;
    } else if (screenWidth > ScreenBreakPoints.mobileBreakPoint && screenWidth < ScreenBreakPoints.desktopBreakPoint) {
      return screenWidth * tabletWidth;
    } else {
      return screenWidth * desktopWidth;
    }
  }
}