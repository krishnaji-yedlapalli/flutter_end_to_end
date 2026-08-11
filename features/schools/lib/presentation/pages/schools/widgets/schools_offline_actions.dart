import 'package:app_core/core/data/db/offline_handler.dart';
import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/core/utils/enums_type_def.dart';
import 'package:ui_kit/mixins/dialogs.dart';
import 'package:ui_kit/presentation/screens/db_configurations_for_devs.dart';
import 'package:ui_kit/presentation/screens/dumping_status.dart';
import 'package:feature_discovery_module/school_feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:schools/shared/models/school_view_model.dart';

class SchoolsOfflineActions extends StatelessWidget with CustomDialogs {
  const SchoolsOfflineActions({super.key});

  OfflineHandler get _offlineHandler => GetIt.instance<OfflineHandler>();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Registered Schools:',
            style: Theme.of(context).textTheme.titleMedium),
        if (DeviceConfiguration.isOfflineSupportedDevice)
          Wrap(
            spacing: 10,
            children: [
              SchoolScreenFeatureDiscovery().aboutSchoolDiscovery(
                  type: SchoolDiscoverFeatureType.sync,
                  child: _buildSyncButton()),
              SchoolScreenFeatureDiscovery().aboutSchoolDiscovery(
                  type: SchoolDiscoverFeatureType.dumpOfflineData,
                  child: _buildDumpOfflineButton()),
              SchoolScreenFeatureDiscovery().aboutSchoolDiscovery(
                  type: SchoolDiscoverFeatureType.setDdConfig,
                  child: _buildDbConfigurationsButtonForDevelopment(context)),
              SchoolScreenFeatureDiscovery().aboutSchoolDiscovery(
                  type: SchoolDiscoverFeatureType.resetDb,
                  child: _buildDbClearButton())
            ],
          )
      ],
    );
  }

  Widget _buildSyncButton() {
    return StreamBuilder<int>(
      stream: _offlineHandler.queueItemsCount.stream,
      initialData: 0,
      builder: (context, snapshot) {
        var count = 0;
        if (snapshot.hasData) {
          count = snapshot.data ?? 0;
        }
        return Badge(
            label: Text('$count'),
            child: ElevatedButton(
                onPressed: _offlineHandler.syncData,
                child: const Text('Sync')));
      },
    );
  }

  Widget _buildDbConfigurationsButtonForDevelopment(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          adaptiveDialog(context, const DbConfigurationDialog());
        },
        child: const Text('Set Db Configurations'));
  }

  Widget _buildDumpOfflineButton() {
    return StreamBuilder<OfflineDumpingStatus>(
      stream: _offlineHandler.dumpingOfflineDataStatus.stream,
      builder: (context, snapshot) {
        Widget child;
        OfflineDumpingStatus status = snapshot.data;
        if (status != null) {
          child = Wrap(
              children: [Text(status.title), Text('${status.percentage}%')]);
        } else {
          child = const Text('Dump Offline Data');
        }
        return ElevatedButton(
            onPressed: () =>
                onTapOfDumpStatus(context, status == null ? false : true),
            child: child);
      },
    );
  }

  Widget _buildDbClearButton() {
    return ElevatedButton.icon(
        onPressed: _offlineHandler.eraseAllDatabaseData,
        icon: const Icon(Icons.refresh),
        label: const Text('Reset Whole Db'));
  }

  onTapOfSchool(BuildContext context, SchoolViewModel school) {
    var query = {"schoolId": school.id};

    context.go(
        Uri(path: '/home/schools/school-details', queryParameters: query)
            .toString(),
        extra: school);
  }

  onTapOfDumpStatus(BuildContext context, bool isRunning) {
    if (!isRunning) _offlineHandler.dumpOfflineData();
    adaptiveDialog(context, const DumpingStatusView());
  }
}
