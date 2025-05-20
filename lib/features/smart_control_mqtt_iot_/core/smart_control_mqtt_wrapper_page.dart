import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:sample_latest/core/data/base_service.dart';
import 'package:sample_latest/features/smart_control_mqtt_iot_/core/smart_control_mqtt_injection_module.dart';

import '../../../core/local_server/widgets/mqtt_server_initilize_wrapper.dart';
import '../features/domain/cubit/smart_control_dashboard_cubit.dart';
import '../features/on_and_off/data/respository/on_off_repository.dart';
import '../features/on_and_off/domain/use_cases/on_off_usecase.dart';
import '../features/on_and_off/presentation/cubit/on_off_cubit.dart';

class SmartControlMqttWrapperPage extends StatefulWidget {
  const SmartControlMqttWrapperPage({super.key, required this.child});

  final Widget child;

  @override
  State<SmartControlMqttWrapperPage> createState() =>
      _SmartControlMqttWrapperPageState();
}

class _SmartControlMqttWrapperPageState extends State<SmartControlMqttWrapperPage> {

  @override
  void initState() {
    SmartControlMqttInjectionModule().registerDependencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var injector = GetIt.instance;

    return PopScope(
      onPopInvokedWithResult: (status, result) {
        if (status) {
          SmartControlMqttInjectionModule().unRegisterDependencies();
        }
      },
      child:  MqttServerInitializeWrapper(
        builder: (BuildContext context, MqttServerClient client) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => OnOffCubit(OnOffUsecase(OnOffRepository(BaseService.instance)))),
              BlocProvider(create: (context) => injector<SmartControlMqttDashboardCubit>(param1: client)),
            ],
            child: widget
                .child,
          );
        },
      ),
    );
  }
}
