import 'package:sample_latest/core/data/utils/abstract_db_handler.dart';

class DbHandlerRegistry {
  final Map<String, DbHandler> _handlers = {};

  void register(DbHandler handler) {
    for (var pattern in handler.supportedPaths) {
      _handlers[pattern] = handler;
    }
  }

  DbHandler? findHandler(String path) {
    for (var entry in _handlers.entries) {
      if (path.contains(entry.key)) return entry.value;
    }
    return null;
  }

  Set<DbHandler> get allHandlers => _handlers.values.toSet();
}
