import 'package:get_it/get_it.dart';
import 'package:app_core/core/data/db/db_config_repository.dart';
import 'package:app_core/core/data/db/db_handler_registry.dart';
import 'package:app_core/core/data/db/module_db_handler/todo_list_db_handler.dart';
import 'package:app_core/core/data/db/offline_handler.dart';
import 'package:schools/data/local/schools_db_handler.dart';

class OfflineInjectionModule {
  OfflineInjectionModule._();

  static final OfflineInjectionModule _instance = OfflineInjectionModule._();

  factory OfflineInjectionModule() => _instance;

  final GetIt _injector = GetIt.instance;

  Future<void> registerDependencies() async {
    await _registerRepository();
    await _registerDbHandlers();
    _registerOfflineHandler();
  }

  Future<void> _registerRepository() async {
    if (!_injector.isRegistered<DbConfigRepository>()) {
      final repository = DbConfigRepository();
      await repository.load();
      _injector.registerSingleton<DbConfigRepository>(repository);
    }
  }

  Future<void> _registerDbHandlers() async {
    final registry = DbHandlerRegistry();

    final schoolsDbHandler = SchoolsDbHandler();
    await schoolsDbHandler.initializeDbIfNot();
    registry.register(schoolsDbHandler);

    final todoListDbHandler = TodoListDbHandler();
    await todoListDbHandler.initializeDbIfNot();
    registry.register(todoListDbHandler);

    if (!_injector.isRegistered<DbHandlerRegistry>()) {
      _injector.registerSingleton<DbHandlerRegistry>(registry);
    }
  }

  void _registerOfflineHandler() {
    if (!_injector.isRegistered<OfflineHandler>()) {
      final offlineHandler = OfflineHandler();
      offlineHandler.initialize(_injector<DbHandlerRegistry>());
      _injector.registerSingleton<OfflineHandler>(offlineHandler);
    }
  }
}
