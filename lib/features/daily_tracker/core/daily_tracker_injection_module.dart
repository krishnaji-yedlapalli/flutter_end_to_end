import 'package:get_it/get_it.dart';
import 'package:sample_latest/core/data/base_service.dart';
import 'package:sample_latest/features/daily_tracker/data/repository/events_repos_impl.dart';
import 'package:sample_latest/features/daily_tracker/data/repository/profiles_repo_impl.dart';
import 'package:sample_latest/features/daily_tracker/domain/repository/events_repository.dart';
import 'package:sample_latest/features/daily_tracker/domain/usecases/check_in_usecase.dart';
import 'package:sample_latest/features/daily_tracker/domain/usecases/create_update_event_usecase.dart';
import 'package:sample_latest/features/daily_tracker/domain/usecases/events_usecase.dart';

import '../../../../core/data/base_service.dart';
import '../data/repository/checkIn_status_repo_impl.dart';
import '../domain/repository/check_in_status_repo.dart';
import '../domain/repository/profiles_repository.dart';
import '../domain/usecases/check_in_status_useCase.dart';
import '../domain/usecases/users_useCase.dart';
import '../features/events/presentation/cubit/events_cubit.dart';
import '../features/greetings/presentation/cubit/check_in_status_cubit.dart';
import '../features/users/presentation/cubit/profiles_cubit.dart';
import '../shared/models/profile_executed_task.dart';

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

  void _registerApiDependencies() {
    injector.registerFactory<BaseService>(() => BaseService.instance);
  }

  void _registerRepositories() {
    injector
      ..registerFactory<ProfilesRepository>(
          () => ProfilesRepositoryImpl(injector()))
      ..registerFactory<EventsRepository>(() => EventRepositoryImpl(injector()))
      ..registerFactory<CheckInStatusRepository>(
          () => CheckInStatusRepositoryImpl(injector()));
  }

  void _registerUseCases() {
    injector
      ..registerFactory<ProfilesUseCase>(() => ProfilesUseCase(injector()))
      ..registerFactory<EventsUseCase>(
          () => EventsUseCase(injector(), injector()))
      ..registerFactory<PerformUserCheckInUseCase>(
          () => PerformUserCheckInUseCase(injector(), injector()))
      ..registerFactory<CheckInStatusUseCase>(
          () => CheckInStatusUseCase(injector(), injector()))
      ..registerFactory<CreateUpdateEventUseCase>(
          () => CreateUpdateEventUseCase(injector(), injector()));
  }

  void _registerBlocs() async {
    injector
      ..registerFactory<CheckInStatusCubit>(
          () => CheckInStatusCubit(injector(), injector(), injector()))
      ..registerFactory<EventsCubit>(
          () => EventsCubit(injector(), injector(), injector()))
      ..registerFactory<ProfilesCubit>(() => ProfilesCubit(injector()));
  }

  void _registerExecutedCacheManager() {
    if (!injector.isRegistered<ProfileExecutedTask>()) {
      injector.registerSingleton<ProfileExecutedTask>(ProfileExecutedTask());
    }
  }

  void _unRegisterDependencies() async {
    // await injector.unregister(instance: SchoolExecutedTaskFlow);
  }
}
