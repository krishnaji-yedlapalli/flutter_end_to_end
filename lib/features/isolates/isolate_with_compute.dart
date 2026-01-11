import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/core/device/enums/device_enums.dart';
import 'package:sample_latest/shared/widgets/responsive_widgets/adaptive_button.dart';
import 'package:sample_latest/features/isolates/presentation/cubit/isolate_cubit.dart';
import 'package:sample_latest/features/isolates/presentation/cubit/isolate_state.dart';
import 'package:sample_latest/features/isolates/presentation/widgets/platform_support_badge.dart';
import 'package:sample_latest/features/isolates/presentation/widgets/performance_metrics_widget.dart';
import 'package:sample_latest/features/isolates/domain/usecases/sort_data_usecase.dart';

class EnhancedIsolateDemo extends StatefulWidget {
  const EnhancedIsolateDemo({Key? key}) : super(key: key);

  @override
  State<EnhancedIsolateDemo> createState() => _EnhancedIsolateDemoState();
}

class _EnhancedIsolateDemoState extends State<EnhancedIsolateDemo> {
  int _recordCount = 10000;
  SortType _sortType = SortType.name;

  bool get _isMobilePlatform {
    final osType = DeviceConfiguration.operatingSystemType;
    return osType == OperatingSystemType.android ||
        osType == OperatingSystemType.ios;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Isolates Demo'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: BlocConsumer<IsolateCubit, IsolateState>(
        listener: (context, state) {
          if (state.error != null) {
            _showErrorDialog(context, state.error!);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPlatformInfo(context),
                const SizedBox(height: 24),
                _buildControls(context, state),
                const SizedBox(height: 24),
                _buildOperationButtons(context, state),
                const SizedBox(height: 24),
                if (state.executionTime != null) ...[
                  PerformanceMetricsWidget(
                    executionTime: state.executionTime,
                    recordCount: state.recordCount,
                    operationType: _getOperationName(state.currentOperation),
                    executionMethod:
                        _getExecutionMethodName(state.executionType),
                  ),
                  const SizedBox(height: 24),
                ],
                _buildResults(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlatformInfo(BuildContext context) {
    final cubit = context.read<IsolateCubit>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Platform Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.devices, size: 20),
              const SizedBox(width: 8),
              Text('Platform: ${cubit.platformName}'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            cubit.supportDescription,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, IsolateState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuration',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          if (_isMobilePlatform) ...[
            // Mobile: Stack vertically
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Record Count: $_recordCount'),
                Slider(
                  value: _recordCount.toDouble(),
                  min: 1000,
                  max: 100000,
                  divisions: 99,
                  onChanged: state.isLoading
                      ? null
                      : (value) {
                          setState(() {
                            _recordCount = value.toInt();
                          });
                        },
                ),
                const SizedBox(height: 16),
                const Text('Sort Type:'),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<SortType>(
                    value: _sortType,
                    isExpanded: true,
                    onChanged: state.isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _sortType = value!;
                            });
                          },
                    items: SortType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name.toUpperCase()),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Desktop: Side by side
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Record Count: $_recordCount'),
                      Slider(
                        value: _recordCount.toDouble(),
                        min: 1000,
                        max: 100000,
                        divisions: 99,
                        onChanged: state.isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _recordCount = value.toInt();
                                });
                              },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sort Type:'),
                      DropdownButton<SortType>(
                        value: _sortType,
                        isExpanded: true,
                        onChanged: state.isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _sortType = value!;
                                });
                              },
                        items: SortType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.name.toUpperCase()),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOperationButtons(BuildContext context, IsolateState state) {
    final cubit = context.read<IsolateCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Isolate Operations',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        // Parse JSON Operations
        _buildOperationSection(
          context,
          'Parse Large JSON',
          [
            _buildOperationButton(
              context,
              'Parse with compute()',
              true,
              state.isLoading,
              () => cubit.parseJsonWithCompute(_recordCount),
            ),
            _buildOperationButton(
              context,
              'Parse with spawn()',
              cubit.supportsSpawn,
              state.isLoading,
              () => cubit.parseJsonWithSpawn(_recordCount),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Sort Data Operations
        _buildOperationSection(
          context,
          'Sort Large Dataset',
          [
            _buildOperationButton(
              context,
              'Sort with compute()',
              true,
              state.isLoading,
              () => cubit.sortDataWithCompute(_recordCount, _sortType),
            ),
            _buildOperationButton(
              context,
              'Sort with spawn()',
              cubit.supportsSpawn,
              state.isLoading,
              () => cubit.sortDataWithSpawn(_recordCount, _sortType),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Statistics Operations
        _buildOperationSection(
          context,
          'Calculate Statistics',
          [
            _buildOperationButton(
              context,
              'Stats with compute()',
              true,
              state.isLoading,
              () => cubit.calculateStatsWithCompute(_recordCount),
            ),
            _buildOperationButton(
              context,
              'Stats with spawn()',
              cubit.supportsSpawn,
              state.isLoading,
              () => cubit.calculateStatsWithSpawn(_recordCount),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Clear Results
        AdaptiveButton(
          text: 'Clear Results',
          onPressed: state.isLoading ? null : () => cubit.clearResults(),
          isPrimary: false,
        ),
      ],
    );
  }

  Widget _buildOperationSection(
    BuildContext context,
    String title,
    List<Widget> buttons,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        if (_isMobilePlatform)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buttons,
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: buttons,
          ),
      ],
    );
  }

  Widget _buildOperationButton(
    BuildContext context,
    String text,
    bool isSupported,
    bool isLoading,
    VoidCallback onPressed,
  ) {
    final cubit = context.read<IsolateCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdaptiveButton(
          text: text,
          onPressed: isLoading
              ? null
              : (isSupported
                  ? onPressed
                  : () => _showUnsupportedDialog(context, text)),
          isPrimary: isSupported,
        ),
        const SizedBox(height: 4),
        PlatformSupportBadge(
          isSupported: isSupported,
          platformName: cubit.platformName,
          onTap:
              !isSupported ? () => _showUnsupportedDialog(context, text) : null,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildResults(BuildContext context, IsolateState state) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Processing data in isolate...'),
          ],
        ),
      );
    }

    if (state.users != null) {
      return _buildUserResults(context, state.users!);
    }

    if (state.statistics != null) {
      return _buildStatisticsResults(context, state.statistics!);
    }

    return const SizedBox.shrink();
  }

  Widget _buildUserResults(BuildContext context, List users) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Results (${users.length} users)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: _isMobilePlatform ? 300 : 200,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: users.length > 10 ? 10 : users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  dense: true,
                  title: Text(
                    user.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${user.city} • Age: ${user.age} • \$${user.salary.toStringAsFixed(0)}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
          if (users.length > 10)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Showing first 10 of ${users.length} results',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatisticsResults(BuildContext context, statistics) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics Results',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildStatItem('Total Users', '${statistics.totalUsers}'),
              _buildStatItem(
                  'Average Age', '${statistics.averageAge.toStringAsFixed(1)}'),
              _buildStatItem('Average Salary',
                  '\$${statistics.averageSalary.toStringAsFixed(0)}'),
              _buildStatItem('Salary Range',
                  '\$${statistics.minSalary.toStringAsFixed(0)} - \$${statistics.maxSalary.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Cities: ${statistics.cityCounts.keys.join(', ')}',
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Operation Failed'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<IsolateCubit>().clearError();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showUnsupportedDialog(BuildContext context, String operation) {
    final cubit = context.read<IsolateCubit>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$operation Not Supported'),
        content: Text(
          '${cubit.supportDescription}\n\n'
          'This operation uses Isolate.spawn() which is not available on web platforms due to security restrictions. '
          'Try using the compute() version instead, or test this feature on mobile/desktop platforms.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String? _getOperationName(IsolateOperationType? type) {
    switch (type) {
      case IsolateOperationType.parseJson:
        return 'Parse JSON';
      case IsolateOperationType.sortData:
        return 'Sort Data';
      case IsolateOperationType.calculateStats:
        return 'Calculate Statistics';
      case null:
        return null;
    }
  }

  String? _getExecutionMethodName(IsolateExecutionType? type) {
    switch (type) {
      case IsolateExecutionType.compute:
        return 'compute()';
      case IsolateExecutionType.spawn:
        return 'Isolate.spawn()';
      case null:
        return null;
    }
  }
}
