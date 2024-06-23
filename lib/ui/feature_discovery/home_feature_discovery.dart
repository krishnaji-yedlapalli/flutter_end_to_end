import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:sample_latest/mixins/buttons_mixin.dart';
import 'package:sample_latest/utils/constants.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/utils/enums_type_def.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenFeatureDiscovery with ButtonMixin {
  factory HomeScreenFeatureDiscovery() {
    return _singleton;
  }

  static final HomeScreenFeatureDiscovery _singleton = HomeScreenFeatureDiscovery._internal();

  HomeScreenFeatureDiscovery._internal();

  static Set<String> features = {'homeFeature', ScreenType.school.name};


  var feature1OverflowMode = OverflowMode.clipContent;
  var feature1EnablePulsingAnimation = false;

  void startFeatureDiscovery(BuildContext context, {bool forceTour = false}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(!forceTour) {
      var status = prefs.getBool(Constants.homeDiscoveryStatus) ?? false;
      if (status) return;
    }

    if(!DeviceConfiguration.isWeb) features.remove('homeFeature');

   FeatureDiscovery.discoverFeatures(
      context,
     features,
    );

    prefs.setBool(Constants.homeDiscoveryStatus, true);
  }

  Widget aboutAppsDiscovery(ValueChanged<String> callback) {
    var widgetToDisplay = const Padding(
      padding: EdgeInsets.all(8.0),
      child: Wrap(
        children: [Icon(Icons.android), Icon(Icons.apple_sharp)],
      ),
    );

    return Builder(builder: (context) {
      return DescribedFeatureOverlay(
        featureId: features.elementAt(0),
        tapTarget: const Wrap(
          children: [Icon(Icons.android), Icon(Icons.apple_sharp)],
        ),
        backgroundColor: Colors.green,
        title: const Text("Try Android & iOS App's"),
        description: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[const Text('Discover how Android and iOS apps utilize Offline, background, and Isolate functionalities.'),
             Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: RichText(text: const TextSpan(
                children: [
                  TextSpan(text: 'Note: ', style: TextStyle(color: Colors.red)),
                  TextSpan(text: 'This Feature Tours was developed using feature_discovery package', style: TextStyle(color: Colors.white))
                ]
              ))
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: customTextButton(label: 'Dismiss', callback: () => FeatureDiscovery.completeCurrentStep(context)),
            )],
        ),
        child: PopupMenuButton(
          onSelected: (val) => callback(val as String),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(
              value: 'android',
              child: Text('Install Android'),
            ),
            const PopupMenuItem(
              value: 'ios',
              child: Text('Install iOS'),
            )
          ],
          // child: widgetToDisplay,
          child: widgetToDisplay
        )
      );
    });
  }

  Widget aboutModuleDiscovery(Widget child, ScreenType type) {
    return Builder(
      builder: (context) {
        return DescribedFeatureOverlay(
          featureId: type.name,
          tapTarget: const Icon(Icons.school),
          backgroundColor: Colors.green,
          title: const Text('School Module'),
          contentLocation: ContentLocation.below,
          description: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                  'School Module has many functionalities, it help us to learn full architecture(Design Pattern) of a Application'),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text('Functionalities holding by this Module:', style: Theme.of(context).textTheme.titleMedium?.apply(color: Colors.lightGreenAccent)),
              ),
              RichText(text: const TextSpan(
                children: [ TextSpan(
                  style: TextStyle(color: Colors.white, height: 1.5),
                  children: [
                    TextSpan(text: '1. Bloc Pattern\n'),
                    TextSpan(text: "2. Rest Api's\n"),
                    TextSpan(text: '3. Offline Support\n'),
                    TextSpan(text: '4. Isolates\n'),
                    TextSpan(text: '5. Running Background Task With Work Manager'),
                    TextSpan(text: '6. CI & CD Pipeline'),
                    TextSpan(text: '7. Push Notifications'),
                    TextSpan(text: '8. Deep Linking'),
                  ]
                )
            ]
              )),
             if(DeviceConfiguration.isWeb) Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: RichText(text: const TextSpan(
                      children: [
                        TextSpan(text: 'Note: ', style: TextStyle(color: Colors.red)),
                        TextSpan(text: " Web platform will not support offline functionality.", style: TextStyle(color: Colors.white))
                      ]
                  ))
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: customTextButton(label: 'Dismiss', callback: () => FeatureDiscovery.dismissAll(context)),
              )
            ],
          ),
          child: child,
        );
      }
    );
  }
}
