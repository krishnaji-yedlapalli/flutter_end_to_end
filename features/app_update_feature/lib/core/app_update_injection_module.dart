import 'package:app_core/core/firebase/services/firebase_remote_config_service.dart';
import 'package:get_it/get_it.dart';

import '../data/repository/app_update_repository_impl.dart';
import '../domain/repository/app_update_repository.dart';
import '../domain/use_cases/check_app_update_use_case.dart';
import '../presentation/cubit/app_update_cubit.dart';

class AppUpdateInjectionModule {
  AppUpdateInjectionModule._();

  static void registerDependencies() {
    final injector = GetIt.instance;

    if (!injector.isRegistered<AppUpdateRepository>()) {
      injector.registerLazySingleton<AppUpdateRepository>(
        () => AppUpdateRepositoryImpl(
          injector<FirebaseRemoteConfigService>(),
        ),
      );
    }

    if (!injector.isRegistered<CheckAppUpdateUseCase>()) {
      injector.registerFactory<CheckAppUpdateUseCase>(
        () => CheckAppUpdateUseCase(injector()),
      );
    }

    if (!injector.isRegistered<AppUpdateCubit>()) {
      injector.registerFactory<AppUpdateCubit>(
        () => AppUpdateCubit(injector()),
      );
    }
  }
}
