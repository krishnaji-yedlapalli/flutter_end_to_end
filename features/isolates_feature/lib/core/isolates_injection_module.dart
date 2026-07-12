import 'package:get_it/get_it.dart';
import 'package:isolates_feature/data/datasources/dummy_data_source.dart';
import 'package:isolates_feature/data/repositories/data_repository_impl.dart';
import 'package:isolates_feature/domain/repositories/i_data_repository.dart';
import 'package:isolates_feature/domain/usecases/calculate_statistics_usecase.dart';
import 'package:isolates_feature/domain/usecases/parse_large_json_usecase.dart';
import 'package:isolates_feature/domain/usecases/sort_data_usecase.dart';
import 'package:isolates_feature/presentation/cubit/isolate_cubit.dart';

class IsolatesInjectionModule {
  static void initializeDependencies() {
    final getIt = GetIt.instance;

    // Data Sources
    getIt.registerLazySingleton<DummyDataSource>(() => DummyDataSource());

    // Repositories
    getIt.registerLazySingleton<IDataRepository>(
      () => DataRepositoryImpl(getIt<DummyDataSource>()),
    );

    // Use Cases
    getIt.registerLazySingleton<ParseLargeJsonUseCase>(
      () => ParseLargeJsonUseCase(getIt<IDataRepository>()),
    );

    getIt.registerLazySingleton<SortDataUseCase>(
      () => SortDataUseCase(getIt<IDataRepository>()),
    );

    getIt.registerLazySingleton<CalculateStatisticsUseCase>(
      () => CalculateStatisticsUseCase(getIt<IDataRepository>()),
    );

    // Cubit
    getIt.registerFactory<IsolateCubit>(
      () => IsolateCubit(
        getIt<ParseLargeJsonUseCase>(),
        getIt<SortDataUseCase>(),
        getIt<CalculateStatisticsUseCase>(),
      ),
    );
  }
}
