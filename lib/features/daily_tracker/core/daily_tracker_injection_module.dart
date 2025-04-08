import 'package:get_it/get_it.dart';

class DailyTrackerInjectionModule {
  DailyTrackerInjectionModule._(); // Private constructor to enforce singleton

  static final DailyTrackerInjectionModule _instance = DailyTrackerInjectionModule._();

  factory DailyTrackerInjectionModule() => _instance;

  final GetIt injector = GetIt.instance;

  Future<void> registerDependencies() async {
    _registerExecutedCacheManager();
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
