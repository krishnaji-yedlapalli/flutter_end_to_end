// Platform-specific implementations
export 'stubs/web_config_stub.dart'
    if (dart.library.html) 'web/web_config.dart';
