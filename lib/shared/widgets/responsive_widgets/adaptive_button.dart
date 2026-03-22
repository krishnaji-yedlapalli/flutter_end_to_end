import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';

/// Adaptive button that uses Material or Cupertino based on platform
class AdaptiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const AdaptiveButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DeviceConfiguration.useCupertinoDesign) {
      return isPrimary
          ? CupertinoButton.filled(
              onPressed: onPressed,
              child: Text(text),
            )
          : CupertinoButton(
              onPressed: onPressed,
              child: Text(text),
            );
    } else {
      return isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              child: Text(text),
            )
          : TextButton(
              onPressed: onPressed,
              child: Text(text),
            );
    }
  }
}
