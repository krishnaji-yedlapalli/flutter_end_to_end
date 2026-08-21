import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/app_update_result.dart';

class OsBlockedScreen extends StatelessWidget {
  final AppUpdateResult result;

  const OsBlockedScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phonelink_erase,
                    size: 80,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    kIsWeb ? 'Browser Not supported' : 'OS Not Supported',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    kIsWeb
                        ? 'Your current browser version is no longer supported'
                        : 'Your current OS version (${result.currentOsVersion}) is no longer supported.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${kIsWeb ? 'Minimum required browser version' : 'Minimum required OS version'}: ${result.minSupportedOsVersion}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    kIsWeb
                        ? 'Please update your browser to continue using this app.'
                        : 'Please update your operating system to continue using this app.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
