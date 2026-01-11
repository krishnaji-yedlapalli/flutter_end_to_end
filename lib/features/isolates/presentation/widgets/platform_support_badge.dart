import 'package:flutter/material.dart';

class PlatformSupportBadge extends StatelessWidget {
  final bool isSupported;
  final String platformName;
  final VoidCallback? onTap;

  const PlatformSupportBadge({
    Key? key,
    required this.isSupported,
    required this.platformName,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isSupported ? Colors.green : Colors.red;

    final icon = isSupported ? Icons.check_circle : Icons.cancel;

    final text = isSupported ? 'Supported' : 'Not Supported on $platformName';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
