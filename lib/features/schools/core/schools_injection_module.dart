import 'package:get_it/get_it.dart';
import 'package:sample_latest/features/schools/shared/models/school_executed_task_model.dart';

class SchoolsInjectionModule {
  SchoolsInjectionModule._(); // Private constructor to enforce singleton

  static final SchoolsInjectionModule _instance = SchoolsInjectionModule._();

  factory SchoolsInjectionModule() => _instance;

  final GetIt injector = GetIt.instance;

  Future<void> registerDependencies() async {
    _registerExecutedCacheManager();
  }

  void _registerExecutedCacheManager() {
    if (!injector.isRegistered<SchoolExecutedTaskFlow>()) {
      injector
          .registerSingleton<SchoolExecutedTaskFlow>(SchoolExecutedTaskFlow());
    }
  }

  void _unRegisterDependencies() async {
    await injector.unregister(instance: SchoolExecutedTaskFlow);
  }
}
