import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_core/core/device/config/device_configurations.dart';

/// Adaptive dialog that shows platform-appropriate dialog
class AdaptiveDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    if (DeviceConfiguration.useCupertinoDesign) {
      return showCupertinoDialog<T>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (cancelText != null)
              CupertinoDialogAction(
                child: Text(cancelText),
                onPressed: () {
                  Navigator.of(context).pop();
                  onCancel?.call();
                },
              ),
            if (confirmText != null)
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(confirmText),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
              ),
          ],
        ),
      );
    } else {
      return showDialog<T>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (cancelText != null)
              TextButton(
                child: Text(cancelText),
                onPressed: () {
                  Navigator.of(context).pop();
                  onCancel?.call();
                },
              ),
            if (confirmText != null)
              ElevatedButton(
                child: Text(confirmText),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
              ),
          ],
        ),
      );
    }
  }
}
