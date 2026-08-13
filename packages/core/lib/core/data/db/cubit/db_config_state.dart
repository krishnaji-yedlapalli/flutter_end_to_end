import 'package:equatable/equatable.dart';

class DbConfigState extends Equatable {
  final bool storeOnlyIfOffline;
  final bool storeInBothOfflineAndOnline;
  final int howLongDataShouldPersist;
  final bool dumpOfflineData;
  final DateTime? lastDeletedOutDataDate;

  const DbConfigState({
    this.storeOnlyIfOffline = false,
    this.storeInBothOfflineAndOnline = false,
    this.howLongDataShouldPersist = 2,
    this.dumpOfflineData = false,
    this.lastDeletedOutDataDate,
  });

  bool get storeData =>
      storeOnlyIfOffline || storeInBothOfflineAndOnline || dumpOfflineData;

  bool get deleteOfflineDataOnceSuccess =>
      storeOnlyIfOffline && !storeInBothOfflineAndOnline && !dumpOfflineData;

  bool get isOutDatedDataNeedsToBeDeleted =>
      storeInBothOfflineAndOnline || dumpOfflineData;

  DbConfigState copyWith({
    bool? storeOnlyIfOffline,
    bool? storeInBothOfflineAndOnline,
    int? howLongDataShouldPersist,
    bool? dumpOfflineData,
    DateTime? lastDeletedOutDataDate,
  }) {
    return DbConfigState(
      storeOnlyIfOffline: storeOnlyIfOffline ?? this.storeOnlyIfOffline,
      storeInBothOfflineAndOnline:
          storeInBothOfflineAndOnline ?? this.storeInBothOfflineAndOnline,
      howLongDataShouldPersist:
          howLongDataShouldPersist ?? this.howLongDataShouldPersist,
      dumpOfflineData: dumpOfflineData ?? this.dumpOfflineData,
      lastDeletedOutDataDate:
          lastDeletedOutDataDate ?? this.lastDeletedOutDataDate,
    );
  }

  @override
  List<Object?> get props => [
        storeOnlyIfOffline,
        storeInBothOfflineAndOnline,
        howLongDataShouldPersist,
        dumpOfflineData,
        lastDeletedOutDataDate,
      ];
}
