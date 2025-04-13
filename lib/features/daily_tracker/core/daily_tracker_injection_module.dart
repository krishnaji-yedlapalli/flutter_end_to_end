import 'package:get_it/get_it.dart';
import 'package:sample_latest/core/data/base_service.dart';
import 'package:sample_latest/features/daily_tracker/data/repository/profiles_repo_impl.dart';

import '../../../../core/data/base_service.dart';
import '../data/repository/checkIn_status_repo_impl.dart';
import '../domain/repository/profiles_repository.dart';
import '../domain/usecases/check_in_status_useCase.dart';
import '../domain/usecases/users_useCase.dart';
import '../features/greetings/presentation/cubit/check_in_status_cubit.dart';
import '../features/users/presentation/cubit/profiles_cubit.dart';

class DailyTrackerInjectionModule {
  DailyTrackerInjectionModule._(); // Private constructor to enforce singleton

  static final DailyTrackerInjectionModule _instance =
      DailyTrackerInjectionModule._();

  factory DailyTrackerInjectionModule() => _instance;

  final GetIt injector = GetIt.instance;

  Future<void> registerDependencies() async {
    _registerExecutedCacheManager();
    _registerApiDependencies();
    _registerRepositories();
    _registerUseCases();
    _registerBlocs();
  }

  void _registerApiDependencies()  {
    injector.registerFactory<BaseService>(() => BaseService.instance);
  }

  void _registerRepositories() {
    injector
      ..registerFactory<ProfilesRepository>(
          () => ProfilesRepositoryImpl(injector()))
      ..registerFactory<CheckInStatusRepositoryImpl>(
          () => CheckInStatusRepositoryImpl(injector()));
  }

  void _registerUseCases() {
    injector
      ..registerFactory<ProfilesUseCase>(() => ProfilesUseCase(injector()))
      ..registerFactory<CheckInStatusUseCase>(
          () => CheckInStatusUseCase(injector()));
  }

  void _registerBlocs() async {
      injector
        ..registerSingleton<ProfilesCubit>(ProfilesCubit(injector()))
      ..registerSingleton<CheckInStatusCubit>(CheckInStatusCubit(injector(), injector(), injector()));
  }

  void _registerExecutedCacheManager() {
    // if (!injector.isRegistered<SchoolExecutedTaskFlow>()) {
    //   injector
    //       .registerSingleton<SchoolExecutedTaskFlow>(SchoolExecutedTaskFlow());
    // }
  }

  void _unRegisterDependencies() async {
    // await injector.unregister(instance: SchoolExecutedTaskFlow);
  }
}
