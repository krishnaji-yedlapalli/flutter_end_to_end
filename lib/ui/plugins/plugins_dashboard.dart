import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/mixins/cards_mixin.dart';
import 'package:sample_latest/utils/enums_type_def.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

class PluginsDashboard extends StatelessWidget with CardWidgetsMixin {
  PluginsDashboard({Key? key}) : super(key: key);

  List<({String name, String des, IconData icon, PluginType type})> pluginList =
      [
        (name: 'Youtube', des: '', icon: Icons.tv, type: PluginType.youtube),
        (name: 'Local Auth', des: 'On local device authentication', icon: Icons.lock, type: PluginType.localAuthentication),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: Text('Plugins'),
          appBar: AppBar(),
        ),
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200),
            itemCount: pluginList.length,
            itemBuilder: (context, index) {
              var plugin = pluginList.elementAt(index);
              return buildHomeCardView(
                  title: plugin.name,
                  des: plugin.des,
                  icon: plugin.icon,
                  callback: () => navigate(context, plugin.type));
            }));
  }

  void navigate(BuildContext context, PluginType type) {
    String path = switch (type) {
      PluginType.youtube => 'youtube',
      PluginType.localAuthentication => 'localAuthentication',
      PluginType.localNotifications => 'localNotifications',
      PluginType.sharePlus => 'sharePlus',
      PluginType.audioPlayer => 'audioPlayer',
      PluginType.networkInfo => 'networkInfo',
    };
      context.go('/home/plugins/$path');
  }
}
