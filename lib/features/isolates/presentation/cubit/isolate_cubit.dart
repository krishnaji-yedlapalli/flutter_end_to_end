import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/core/device/enums/device_enums.dart';
import 'package:sample_latest/features/isolates/domain/usecases/parse_large_json_usecase.dart';
import 'package:sample_latest/features/isolates/domain/usecases/sort_data_usecase.dart';
import 'package:sample_latest/features/isolates/domain/usecases/calculate_statistics_usecase.dart';
import 'package:sample_latest/features/isolates/shared/isolate_manager.dart';
import 'package:sample_latest/features/isolates/shared/compute_isolate_manager.dart';
import 'package:sample_latest/features/isolates/shared/spawn_isolate_manager.dart';
import 'package:sample_latest/features/isolates/presentation/cubit/isolate_state.dart';

class IsolateCubit extends Cubit<IsolateState> {
  final ParseLargeJsonUseCase _parseJsonUseCase;
  final SortDataUseCase _sortDataUseCase;
  final CalculateStatisticsUseCase _calculateStatsUseCase;

  late final IsolateManager _isolateManager;

  IsolateCubit(
    this._parseJsonUseCase,
    this._sortDataUseCase,
    this._calculateStatsUseCase,
  ) : super(const IsolateState()) {
    _initializeIsolateManager();
  }

  void _initializeIsolateManager() {
    final osType = DeviceConfiguration.operatingSystemType;
    if (osType == OperatingSystemType.web) {
      _isolateManager = ComputeIsolateManager();
    } else {
      _isolateManager = SpawnIsolateManager();
    }
  }

  bool get supportsSpawn => _isolateManager.supportsSpawn;
  String get platformName => _isolateManager.platformName;
  String get supportDescription => _isolateManager.supportDescription;

  Future<void> parseJsonWithCompute(int recordCount) async {
    await _executeOperation(
      operation: IsolateOperationType.parseJson,
      executionType: IsolateExecutionType.compute,
      recordCount: recordCount,
      task: () async {
        final users = await _isolateManager.executeWithCompute(
          ParseLargeJsonUseCase.parseJsonInIsolate,
          await _parseJsonUseCase.repository.fetchLargeJsonString(recordCount),
        );
        return state.copyWith(users: users);
      },
    );
  }

  Future<void> parseJsonWithSpawn(int recordCount) async {
    if (!supportsSpawn) {
      emit(state.copyWith(
        error:
            'Isolate.spawn() is not supported on ${_isolateManager.platformName}. ${_isolateManager.supportDescription}',
      ));
      return;
    }

    await _executeOperation(
      operation: IsolateOperationType.parseJson,
      executionType: IsolateExecutionType.spawn,
      recordCount: recordCount,
      task: () async {
        final users = await _isolateManager.executeWithSpawn(
          ParseLargeJsonUseCase.parseJsonInIsolate,
          await _parseJsonUseCase.repository.fetchLargeJsonString(recordCount),
        );
        return state.copyWith(users: users);
      },
    );
  }

  Future<void> sortDataWithCompute(int recordCount, SortType sortType) async {
    await _executeOperation(
      operation: IsolateOperationType.sortData,
      executionType: IsolateExecutionType.compute,
      recordCount: recordCount,
      task: () async {
        final userData =
            await _sortDataUseCase.repository.fetchLargeUserData(recordCount);
        final users = await _isolateManager.executeWithCompute(
          (Map<String, dynamic> data) => SortDataUseCase.sortUsersInIsolate(
              data['userData'] as List<Map<String, dynamic>>,
              data['sortType'] as SortType),
          {
            'userData': userData,
            'sortType': sortType,
          },
        );
        return state.copyWith(users: users);
      },
    );
  }

  Future<void> sortDataWithSpawn(int recordCount, SortType sortType) async {
    if (!supportsSpawn) {
      emit(state.copyWith(
        error:
            'Isolate.spawn() is not supported on ${_isolateManager.platformName}. ${_isolateManager.supportDescription}',
      ));
      return;
    }

    await _executeOperation(
      operation: IsolateOperationType.sortData,
      executionType: IsolateExecutionType.spawn,
      recordCount: recordCount,
      task: () async {
        final userData =
            await _sortDataUseCase.repository.fetchLargeUserData(recordCount);
        final users = await _isolateManager.executeWithSpawn(
          (Map<String, dynamic> data) => SortDataUseCase.sortUsersInIsolate(
              data['userData'] as List<Map<String, dynamic>>,
              data['sortType'] as SortType),
          {
            'userData': userData,
            'sortType': sortType,
          },
        );
        return state.copyWith(users: users);
      },
    );
  }

  Future<void> calculateStatsWithCompute(int recordCount) async {
    await _executeOperation(
      operation: IsolateOperationType.calculateStats,
      executionType: IsolateExecutionType.compute,
      recordCount: recordCount,
      task: () async {
        final stats = await _isolateManager.executeWithCompute(
          CalculateStatisticsUseCase.calculateStatisticsInIsolate,
          await _calculateStatsUseCase.repository
              .fetchLargeUserData(recordCount),
        );
        return state.copyWith(statistics: stats);
      },
    );
  }

  Future<void> calculateStatsWithSpawn(int recordCount) async {
    if (!supportsSpawn) {
      emit(state.copyWith(
        error:
            'Isolate.spawn() is not supported on ${_isolateManager.platformName}. ${_isolateManager.supportDescription}',
      ));
      return;
    }

    await _executeOperation(
      operation: IsolateOperationType.calculateStats,
      executionType: IsolateExecutionType.spawn,
      recordCount: recordCount,
      task: () async {
        final stats = await _isolateManager.executeWithSpawn(
          CalculateStatisticsUseCase.calculateStatisticsInIsolate,
          await _calculateStatsUseCase.repository
              .fetchLargeUserData(recordCount),
        );
        return state.copyWith(statistics: stats);
      },
    );
  }

  Future<void> _executeOperation({
    required IsolateOperationType operation,
    required IsolateExecutionType executionType,
    required int recordCount,
    required Future<IsolateState> Function() task,
  }) async {
    emit(state.copyWith(
      isLoading: true,
      error: null,
      currentOperation: operation,
      executionType: executionType,
      recordCount: recordCount,
    ));

    final stopwatch = Stopwatch()..start();

    try {
      final newState = await task();
      stopwatch.stop();

      emit(newState.copyWith(
        isLoading: false,
        executionTime: stopwatch.elapsed,
      ));
    } catch (e) {
      stopwatch.stop();
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
        executionTime: stopwatch.elapsed,
      ));
    }
  }

  void clearResults() {
    emit(state.clearResults());
  }

  void clearError() {
    emit(state.clearError());
  }
}
