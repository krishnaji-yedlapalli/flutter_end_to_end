import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../../shared/models/smart_control_model.dart';
import '../../mock/smart_control_seed.dart';

part 'smart_control_dashboard_state.dart';

class SmartControlMqttDashboardCubit extends Cubit<ScDashboardState> {
  final MqttServerClient _mqttServerClient;

  SmartControlMqttDashboardCubit(this._mqttServerClient)
      : super(SCDashboardLoading());

  Future<void> loadSmartControlDashboard() async {
    emit(SCDashboardLoaded(SmartControlSeed.dashboardSeed, _mqttServerClient));
  }
}
