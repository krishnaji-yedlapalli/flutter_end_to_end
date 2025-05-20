
part of 'smart_control_dashboard_cubit.dart';

abstract class ScDashboardState extends Equatable {

}

class SCDashboardLoading extends ScDashboardState {
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class SCDashboardLoaded extends ScDashboardState {

  final List<SmartControlMqttModel> smItems;
  final MqttServerClient mqttServerClient;

  SCDashboardLoaded(this.smItems, this.mqttServerClient);

  @override
  // TODO: implement props
  List<Object?> get props => [smItems];

}