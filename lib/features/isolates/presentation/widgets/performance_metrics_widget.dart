import 'package:flutter/material.dart';

class PerformanceMetricsWidget extends StatelessWidget {
  final Duration? executionTime;
  final int? recordCount;
  final String? operationType;
  final String? executionMethod;

  const PerformanceMetricsWidget({
    Key? key,
    this.executionTime,
    this.recordCount,
    this.operationType,
    this.executionMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (executionTime == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.speed,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Performance Metrics',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMetricRow(
            context,
            'Execution Time',
            '${executionTime!.inMilliseconds}ms',
            Icons.timer,
          ),
          if (recordCount != null) ...[
            const SizedBox(height: 8),
            _buildMetricRow(
              context,
              'Records Processed',
              recordCount!.toString(),
              Icons.dataset,
            ),
          ],
          if (operationType != null) ...[
            const SizedBox(height: 8),
            _buildMetricRow(
              context,
              'Operation',
              operationType!,
              Icons.settings,
            ),
          ],
          if (executionMethod != null) ...[
            const SizedBox(height: 8),
            _buildMetricRow(
              context,
              'Method',
              executionMethod!,
              Icons.code,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon,
            size: 16,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }
}
