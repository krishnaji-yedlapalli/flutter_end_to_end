
part of 'smart_control_dashboard_cubit.dart';

abstract class ScDashboardState extends Equatable {

}

class SCDashboardLoading extends ScDashboardState {
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class SCDashboardLoaded extends ScDashboardState {

  final List<SmartControlModel> smItems;
  final Map<String, SmartDeviceControlCubit> smCubits;

  SCDashboardLoaded(this.smItems, this.smCubits);

  @override
  // TODO: implement props
  List<Object?> get props => [];

}