import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Adaptive slider
class AdaptiveSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;

  const AdaptiveSlider({
    Key? key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DeviceConfiguration.useCupertinoDesign) {
      return CupertinoSlider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
        divisions: divisions,
      );
    } else {
      return Slider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
        divisions: divisions,
      );
    }
  }
}
