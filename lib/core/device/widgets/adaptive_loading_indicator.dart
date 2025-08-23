import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../config/device_configurations.dart';

/// Adaptive loading indicator
class AdaptiveLoadingIndicator extends StatelessWidget {
  final double? value;
  final Color? color;

  const AdaptiveLoadingIndicator({
    Key? key,
    this.value,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DeviceConfiguration.useCupertinoDesign) {
      return CupertinoActivityIndicator(
        color: color,
      );
    } else {
      return CircularProgressIndicator(
        value: value,
        color: color,
      );
    }
  }
}
