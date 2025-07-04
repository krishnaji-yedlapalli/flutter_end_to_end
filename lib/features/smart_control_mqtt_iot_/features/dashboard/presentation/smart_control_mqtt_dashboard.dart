import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:sample_latest/core/mixins/loaders.dart';

import '../../../../../core/device/enums/device_enums.dart';
import '../../../../../core/device/widgets/adaptive_layout_builder.dart';
import '../../../../../core/mixins/cards_mixin.dart';
import '../../../core/smart_control_mqtt_router_module.dart';
import '../../../shared/models/smart_control_model.dart';
import '../../../shared/utils/enums.dart';
import '../../domain/cubit/smart_control_dashboard_cubit.dart';
import '../../smart_device_control/presentation/cubit/smart_device_mqtt_control_cubit.dart';
import '../../smart_device_control/presentation/smart_control_tile.dart';

class SmartControlMqttDashboard extends StatefulWidget {
  const SmartControlMqttDashboard({super.key});

  @override
  State<SmartControlMqttDashboard> createState() => _SmartControlMqttDashboardState();
}

class _SmartControlMqttDashboardState extends State<SmartControlMqttDashboard>
    with CardWidgetsMixin, Loaders {

  @override
  Widget build(BuildContext context) {
    context.read<SmartControlMqttDashboardCubit>().loadSmartControlDashboard();
    return SafeArea(
      child: Scaffold(
          body: BlocBuilder<SmartControlMqttDashboardCubit, ScDashboardState>(
              builder: (context, ScDashboardState state) {
                if (state is SCDashboardLoaded) {
                    return _buildGridView(state.smItems, state.mqttServerClient);
                } else {
                  return circularLoader();
                }
              })
      ),
    );
  }

  Padding _buildGridView(List<SmartControlMqttModel> screenTypes, MqttServerClient client) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AdaptiveLayoutBuilder(
          builder: (context, deviceType) {
           return StaggeredGrid.count(
                crossAxisCount: deviceType == DeviceResolutionType.mobile
                    ? 3
                    : 8,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: screenTypes.map((screenType) {
                  final count = getCellCount(screenType.tileType);

                   return StaggeredGridTile.count(
                        crossAxisCellCount: count.$1,
                        mainAxisCellCount: count.$2,
                        child: SmartControlTile(smartControlModel: screenType,
                          mqttServerClient: client,)

                    );
           }
                   ).toList()
            );
          }),
    );
  }

  (int, int) getCellCount(TileSizeType  type) {
    switch(type){
      case TileSizeType.large:
        return (2,2);
      case TileSizeType.medium:
        return (2,1);
      case TileSizeType.small:
        return (1,1);
    }
  }


  navigateToControl(SmartControlType type) {
    switch (type) {
      case SmartControlType.onOff:
        GoRouter.of(context).go(SmartControlMqttRouterModule.onAndOffPath);
      case SmartControlType.motionDetector:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
