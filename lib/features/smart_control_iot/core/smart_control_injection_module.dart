import 'package:get_it/get_it.dart';

import '../../../core/data/base_service.dart';
import '../features/domain/cubit/smart_control_dashboard_cubit.dart';
import '../features/smart_device_control/data/respository/smart_device_control_repo_impl.dart';
import '../features/smart_device_control/domain/repository/smart_device_control_repo.dart';
import '../features/smart_device_control/domain/use_cases/device_status_useCase.dart';
import '../features/smart_device_control/domain/use_cases/smart_device_ctrl_useCase.dart';



class SmartControlInjectionModule {
  SmartControlInjectionModule._(); // Private constructor to enforce singleton

  static final SmartControlInjectionModule _instance =
  SmartControlInjectionModule._();

  factory SmartControlInjectionModule() => _instance;

  final GetIt injector = GetIt.instance;

  void registerDependencies() {
    _registerApiDependencies();
    _registerRepositories();
    _registerUseCases();
    _registerBlocs();
  }

  void _registerApiDependencies() {
    injector.registerFactory<BaseService>(() => BaseService.instance);
  }

  void _registerRepositories() {
    injector
      .registerFactory<SmartDeviceControlRepository>(
          () => SmartDeviceControlRepositoryImpl(injector()));
  }

  void _registerUseCases() {
    injector
      ..registerFactory<SmartDeviceStatusUseCase>(() => SmartDeviceStatusUseCase(injector()))
      ..registerFactory<SmartDeviceControlUseCase>(
          () => SmartDeviceControlUseCase(injector()));
  }

  void _registerBlocs() {
    injector
      .registerFactory<SmartControlDashboardCubit>(() => SmartControlDashboardCubit(injector(), injector()));
  }

  void unRegisterDependencies() {
    // Unregister Blocs
    injector
      .unregister<SmartControlDashboardCubit>();

    // Unregister Use Cases
    injector
      ..unregister<SmartDeviceStatusUseCase>()
      ..unregister<SmartDeviceControlUseCase>();

    // Unregister Repositories
    injector
      .unregister<SmartDeviceControlRepository>();

    // Unregister Services
    injector.unregister<BaseService>();
  }
}
