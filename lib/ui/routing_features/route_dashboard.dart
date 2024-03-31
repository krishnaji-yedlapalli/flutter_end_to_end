

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/mixins/cards_mixin.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

import '../../utils/enums_type_def.dart';

class RoutingDashboard extends StatelessWidget  with CardWidgetsMixin {

   RoutingDashboard({Key? key}) : super(key: key);

  final List<(String, RouteType, IconData, {String? des})> screenTypes = [
   ('Shell Route', RouteType.shellRouting, Icons.route, des : ""),
   ('Stateful Shell Routing', RouteType.stateFullShellRoutingWithIndexed, Icons.route, des : "Nested routing will work based on the index"),
   ('Shell l', RouteType.stateFullShellRoutingWithoutIndexed, Icons.route, des : ""),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Different types of Routes'),
        appBar: AppBar(),
      ),
      body: GridView.builder(
          itemCount: screenTypes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: DeviceConfiguration.isMobileResolution ? 2 : 6),
          itemBuilder: (_, index) {
            var screenDetails = screenTypes.elementAt(index);
            return buildHomeCardView(
                title: screenDetails.$1,
                des: screenDetails.des ?? '',
                icon: screenDetails.$3,
                callback: () =>
                    navigateToDashboard(context, screenTypes.elementAt(index).$2));
          }),
    );
  }

   navigateToDashboard(BuildContext context, RouteType type) {
     String path = switch (type) {
     RouteType.shellRouting => '/home/route/shellroute/child1',
       RouteType.stateFullShellRoutingWithIndexed => '/home/route/${type.name}/hi',
       RouteType.stateFullShellRoutingWithoutIndexed => throw UnimplementedError(),
     };
     context.go(path);
   }
}
