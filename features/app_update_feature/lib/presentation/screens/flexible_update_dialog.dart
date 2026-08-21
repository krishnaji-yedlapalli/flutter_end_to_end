import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/app_update_result.dart';

class FlexibleUpdateDialog extends StatelessWidget {
  final AppUpdateResult result;

  const FlexibleUpdateDialog({super.key, required this.result});

  static Future<void> show(BuildContext context, AppUpdateResult result) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => FlexibleUpdateDialog(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.system_update_alt,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('Update Available'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'A new version (${result.latestAppVersion}) is available.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Current version: ${result.currentAppVersion}',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Later'),
        ),
        FilledButton(
          onPressed: () => _openUpdateUrl(context),
          child: const Text('Update'),
        ),
      ],
    );
  }

  Future<void> _openUpdateUrl(BuildContext context) async {
    final uri = Uri.parse(result.updateUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open update URL')),
        );
      }
    }
  }
}
