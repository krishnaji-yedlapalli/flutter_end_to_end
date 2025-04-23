import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:sample_latest/core/mixins/buttons_mixin.dart';
import 'package:sample_latest/core/utils/constants.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/core/utils/enums_type_def.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolScreenFeatureDiscovery with ButtonMixin {
  factory SchoolScreenFeatureDiscovery() {
    return _singleton;
  }

  static final SchoolScreenFeatureDiscovery _singleton =
      SchoolScreenFeatureDiscovery._internal();

  SchoolScreenFeatureDiscovery._internal();

  static Set<String> features = {};

  var feature1OverflowMode = OverflowMode.clipContent;
  var feature1EnablePulsingAnimation = false;
  var isCompleted = false;

  void startFeatureDiscovery(BuildContext context,
      {bool forceTour = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isCompleted && !forceTour) {
      return;
    } else if (!forceTour) {
      var status = prefs.getBool(Constants.schoolDiscoveryStatus) ?? false;
      if (status) return;
    }

    if (DeviceConfiguration.isWeb) {
      features = {
        SchoolDiscoverFeatureType.create.name,
        SchoolDiscoverFeatureType.edit.name,
        SchoolDiscoverFeatureType.delete.name
      };
    } else {
      features = {
        SchoolDiscoverFeatureType.create.name,
        SchoolDiscoverFeatureType.sync.name,
        SchoolDiscoverFeatureType.dumpOfflineData.name,
        SchoolDiscoverFeatureType.setDdConfig.name,
        SchoolDiscoverFeatureType.resetDb.name
      };
    }

    FeatureDiscovery.discoverFeatures(
      context,
      features,
    );

    prefs.setBool(Constants.schoolDiscoveryStatus, true);
    isCompleted = true;
  }

  Widget aboutSchoolDiscovery(
      {required Widget child, required SchoolDiscoverFeatureType type}) {
    return Builder(builder: (context) {
      return DescribedFeatureOverlay(
        featureId: type.name,
        tapTarget: Icon(icon(type)),
        backgroundColor: Colors.green,
        title: Text(title(type)),
        contentLocation: contentLocation(type),
        description: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(des(type)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: customTextButton(
                  label: 'Dismiss',
                  callback: () => FeatureDiscovery.dismissAll(context)),
            )
          ],
        ),
        child: child,
      );
    });
  }

  IconData icon(SchoolDiscoverFeatureType type) => switch (type) {
        SchoolDiscoverFeatureType.create => Icons.add,
        SchoolDiscoverFeatureType.edit => Icons.edit,
        SchoolDiscoverFeatureType.delete => Icons.delete,
        SchoolDiscoverFeatureType.sync => Icons.sync,
        SchoolDiscoverFeatureType.dumpOfflineData => Icons.download_for_offline,
        SchoolDiscoverFeatureType.setDdConfig =>
          Icons.confirmation_num_outlined,
        SchoolDiscoverFeatureType.resetDb => Icons.reset_tv
      };

  String title(SchoolDiscoverFeatureType type) => switch (type) {
        SchoolDiscoverFeatureType.create => 'Create a School',
        SchoolDiscoverFeatureType.edit => 'Edit a School',
        SchoolDiscoverFeatureType.delete => 'Delete a School',
        SchoolDiscoverFeatureType.sync => 'Sync the Data',
        SchoolDiscoverFeatureType.dumpOfflineData => 'Dump Offline Data',
        SchoolDiscoverFeatureType.setDdConfig => 'Set Offline Configuration',
        SchoolDiscoverFeatureType.resetDb => 'Reset Whole Db',
      };

  String des(SchoolDiscoverFeatureType type) => switch (type) {
        SchoolDiscoverFeatureType.create =>
          'Create a School in both Offline and Online',
        SchoolDiscoverFeatureType.edit => 'Edit a School',
        SchoolDiscoverFeatureType.delete => 'Delete a School',
        SchoolDiscoverFeatureType.sync =>
          'What ever operations performed in Offline they shown up here with Badge count. \nOn Tap Offline data will sync with Server. if there is Network Connectivity it will automatically Sync with the Server. \n It uses Work Manager manager to Sync the data when app is in Background or terminated. \n For Automatic Syncing it will uses network_info_plus.',
        SchoolDiscoverFeatureType.dumpOfflineData =>
          'It Dumps Huge Data in Local DB for Offline Usage. It uses dart Isolates for smooth functionality by running code in another isolate',
        SchoolDiscoverFeatureType.setDdConfig =>
          'Until unless without setting DB configuration, Offline Mode won\'t be enabled',
        SchoolDiscoverFeatureType.resetDb =>
          'Delete\'s whole data in db tables',
      };

  ContentLocation contentLocation(SchoolDiscoverFeatureType type) =>
      switch (type) {
        SchoolDiscoverFeatureType.create => ContentLocation.trivial,
        SchoolDiscoverFeatureType.edit ||
        SchoolDiscoverFeatureType.delete ||
        SchoolDiscoverFeatureType.sync ||
        SchoolDiscoverFeatureType.dumpOfflineData ||
        SchoolDiscoverFeatureType.setDdConfig ||
        SchoolDiscoverFeatureType.resetDb =>
          ContentLocation.below
      };
}
