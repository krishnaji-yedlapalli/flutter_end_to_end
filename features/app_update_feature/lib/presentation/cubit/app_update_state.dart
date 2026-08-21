import 'package:equatable/equatable.dart';

import '../../domain/entities/app_update_result.dart';

abstract class AppUpdateState extends Equatable {
  const AppUpdateState();

  @override
  List<Object?> get props => [];
}

class AppUpdateInitial extends AppUpdateState {}

class AppUpdateLoading extends AppUpdateState {}

class AppUpdateChecked extends AppUpdateState {
  final AppUpdateResult result;

  const AppUpdateChecked(this.result);

  @override
  List<Object?> get props => [result];
}

class AppUpdateError extends AppUpdateState {
  final String message;

  const AppUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}
