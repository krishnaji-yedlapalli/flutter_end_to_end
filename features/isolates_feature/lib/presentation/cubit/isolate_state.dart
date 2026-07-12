import 'package:isolates_feature/domain/entities/user.dart';
import 'package:isolates_feature/domain/usecases/calculate_statistics_usecase.dart';

enum IsolateOperationType {
  parseJson,
  sortData,
  calculateStats,
}

enum IsolateExecutionType {
  compute,
  spawn,
}

class IsolateState {
  final bool isLoading;
  final String? error;
  final List<User>? users;
  final DataStatistics? statistics;
  final Duration? executionTime;
  final IsolateOperationType? currentOperation;
  final IsolateExecutionType? executionType;
  final int? recordCount;

  const IsolateState({
    this.isLoading = false,
    this.error,
    this.users,
    this.statistics,
    this.executionTime,
    this.currentOperation,
    this.executionType,
    this.recordCount,
  });

  IsolateState copyWith({
    bool? isLoading,
    String? error,
    List<User>? users,
    DataStatistics? statistics,
    Duration? executionTime,
    IsolateOperationType? currentOperation,
    IsolateExecutionType? executionType,
    int? recordCount,
  }) {
    return IsolateState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      users: users ?? this.users,
      statistics: statistics ?? this.statistics,
      executionTime: executionTime ?? this.executionTime,
      currentOperation: currentOperation ?? this.currentOperation,
      executionType: executionType ?? this.executionType,
      recordCount: recordCount ?? this.recordCount,
    );
  }

  IsolateState clearError() {
    return copyWith(error: null);
  }

  IsolateState clearResults() {
    return copyWith(
      users: null,
      statistics: null,
      executionTime: null,
      currentOperation: null,
      executionType: null,
      recordCount: null,
    );
  }
}
