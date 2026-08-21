import 'dart:io';

import 'package:app_core/core/firebase/config/remote_config_keys.dart';
import 'package:app_core/core/firebase/services/firebase_remote_config_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../data/utils/os_version_parser.dart';
import '../../domain/entities/app_update_result.dart';
import '../constants/app_update_demo_constants.dart';
import '../cubit/app_update_cubit.dart';
import '../cubit/app_update_state.dart';
import '../screens/flexible_update_dialog.dart';
import '../screens/force_update_screen.dart';
import '../screens/os_blocked_screen.dart';

class AppUpdateDemoPage extends StatefulWidget {
  const AppUpdateDemoPage({super.key});

  @override
  State<AppUpdateDemoPage> createState() => _AppUpdateDemoPageState();
}

class _AppUpdateDemoPageState extends State<AppUpdateDemoPage> {
  // Simulated values used for Execute — independent of real device info
  String _selectedOsVersion = '15';
  String _selectedAppVersion = '1.0.0';

  // Real device info — display only
  String _currentOsVersion = '';
  String _currentAppVersion = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentDeviceInfo();
  }

  Future<void> _loadCurrentDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final osVersion = await OsVersionParser.getCurrentOsVersion();
    setState(() {
      _currentAppVersion = packageInfo.version;
      _currentOsVersion = osVersion.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppUpdateCubit, AppUpdateState>(
      listener: _onStateChanged,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('App Update Demo'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCurrentInfoCard(context),
              const SizedBox(height: 16),
              _buildRemoteConfigCard(context),
              const SizedBox(height: 16),
              _buildSimulationCard(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows real device info — for reference only, not used in simulation.
  Widget _buildCurrentInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Device Info',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            _buildInfoRow(
              context,
              'Platform',
              kIsWeb ? 'Web' : Platform.operatingSystem.toUpperCase(),
            ),
            _buildInfoRow(context, 'OS Version', _currentOsVersion),
            _buildInfoRow(context, 'App Version', _currentAppVersion),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoteConfigCard(BuildContext context) {
    final remoteConfig = GetIt.instance<FirebaseRemoteConfigService>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Remote Config Thresholds',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            _buildInfoRow(
              context,
              'Min OS (Web)',
              remoteConfig.getString(RemoteConfigKeys.minSupportedOsVersionWeb),
            ),
            _buildInfoRow(
              context,
              'Min OS (Android)',
              remoteConfig
                  .getString(RemoteConfigKeys.minSupportedOsVersionAndroid),
            ),
            _buildInfoRow(
              context,
              'Min OS (iOS)',
              remoteConfig.getString(RemoteConfigKeys.minSupportedOsVersionIos),
            ),
            _buildInfoRow(
              context,
              'Min OS (macOS)',
              remoteConfig
                  .getString(RemoteConfigKeys.minSupportedOsVersionMacos),
            ),
            _buildInfoRow(
              context,
              'Min App Version',
              remoteConfig.getString(RemoteConfigKeys.minSupportedAppVersion),
            ),
            _buildInfoRow(
              context,
              'Latest App Version',
              remoteConfig.getString(RemoteConfigKeys.latestAppVersion),
            ),
            _buildInfoRow(
              context,
              'Update URL',
              remoteConfig.getString(RemoteConfigKeys.appUpdateUrl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulationCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Simulate Update Check',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedOsVersion,
              decoration: const InputDecoration(
                labelText: 'OS Version',
                border: OutlineInputBorder(),
              ),
              items: AppUpdateDemoConstants.osVersionOptions
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedOsVersion = value);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedAppVersion,
              decoration: const InputDecoration(
                labelText: 'App Version',
                border: OutlineInputBorder(),
              ),
              items: AppUpdateDemoConstants.appVersionOptions
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedAppVersion = value);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _onExecute,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Execute'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Flexible(
            child: Text(
              value.isEmpty ? '(not set)' : value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    value.isEmpty ? Theme.of(context).colorScheme.error : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Runs the check using the dropdown-selected values, not real device info.
  void _onExecute() {
    context.read<AppUpdateCubit>().checkWithSimulatedValues(
          osVersion: _selectedOsVersion,
          appVersion: _selectedAppVersion,
        );
  }

  void _onStateChanged(BuildContext context, AppUpdateState state) {
    if (state is AppUpdateChecked) {
      switch (state.result.status) {
        case AppUpdateStatus.osUnsupported:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OsBlockedScreen(result: state.result),
            ),
          );
        case AppUpdateStatus.forceUpdateRequired:
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ForceUpdateScreen(result: state.result),
            ),
          );
        case AppUpdateStatus.flexibleUpdateAvailable:
          FlexibleUpdateDialog.show(context, state.result);
        case AppUpdateStatus.upToDate:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ App is up to date!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
      }
    } else if (state is AppUpdateError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.message}')),
      );
    }
  }
}
