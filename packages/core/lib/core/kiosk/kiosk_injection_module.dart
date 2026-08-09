import 'package:get_it/get_it.dart';
import 'package:app_core/core/kiosk/controllers/backlight_controller.dart';
import 'package:app_core/core/kiosk/controllers/exit_gesture_detector.dart';
import 'package:app_core/core/kiosk/controllers/window_manager.dart';
import 'package:app_core/core/kiosk/kiosk_service.dart';
import 'package:app_core/core/kiosk/kiosk_service_impl.dart';
import 'package:app_core/core/kiosk/platform/linux_process_runner.dart';
import 'package:app_core/core/kiosk/platform/sysfs_writer.dart';
import 'package:app_core/core/kiosk/services/deep_sleep_scheduler.dart';
import 'package:app_core/core/kiosk/services/inactivity_timer.dart';
import 'package:app_core/core/kiosk/services/schedule_persistence.dart';

/// Dependency injection module for the Kiosk Service and its sub-components.
///
/// Registers all kiosk dependencies in `get_it` as lazy singletons.
/// Dependencies are registered in the correct order so that each component's
/// dependencies are available when needed.
class KioskInjectionModule {
  KioskInjectionModule._();

  static final KioskInjectionModule _instance = KioskInjectionModule._();

  factory KioskInjectionModule() => _instance;

  final GetIt injector = GetIt.instance;

  void registerDependencies() {
    // Platform abstractions (no dependencies)
    if (!injector.isRegistered<ISysfsWriter>()) {
      injector.registerLazySingleton<ISysfsWriter>(
        () => SysfsWriterImpl(),
      );
    }

    if (!injector.isRegistered<ILinuxProcessRunner>()) {
      injector.registerLazySingleton<ILinuxProcessRunner>(
        () => LinuxProcessRunnerImpl(),
      );
    }

    // Controllers that depend on platform abstractions
    if (!injector.isRegistered<IBacklightController>()) {
      injector.registerLazySingleton<IBacklightController>(
        () => BacklightControllerImpl(
          sysfsWriter: injector<ISysfsWriter>(),
          processRunner: injector<ILinuxProcessRunner>(),
        ),
      );
    }

    if (!injector.isRegistered<IInactivityTimer>()) {
      injector.registerLazySingleton<IInactivityTimer>(
        () => InactivityTimerImpl(),
      );
    }

    if (!injector.isRegistered<IExitGestureDetector>()) {
      injector.registerLazySingleton<IExitGestureDetector>(
        () => ExitGestureDetectorImpl(),
      );
    }

    if (!injector.isRegistered<ISchedulePersistence>()) {
      injector.registerLazySingleton<ISchedulePersistence>(
        () => SchedulePersistenceImpl(),
      );
    }

    // Services that depend on platform abstractions and persistence
    if (!injector.isRegistered<IDeepSleepScheduler>()) {
      injector.registerLazySingleton<IDeepSleepScheduler>(
        () => DeepSleepSchedulerImpl(
          persistence: injector<ISchedulePersistence>(),
          sysfsWriter: injector<ISysfsWriter>(),
          processRunner: injector<ILinuxProcessRunner>(),
        ),
      );
    }

    if (!injector.isRegistered<IWindowManager>()) {
      injector.registerLazySingleton<IWindowManager>(
        () => WindowManagerImpl(
          processRunner: injector<ILinuxProcessRunner>(),
        ),
      );
    }

    // Facade that depends on all sub-components
    if (!injector.isRegistered<IKioskService>()) {
      injector.registerLazySingleton<IKioskService>(
        () => KioskServiceImpl(
          backlightController: injector<IBacklightController>(),
          inactivityTimer: injector<IInactivityTimer>(),
          exitGestureDetector: injector<IExitGestureDetector>(),
          deepSleepScheduler: injector<IDeepSleepScheduler>(),
          windowManager: injector<IWindowManager>(),
        ),
      );
    }
  }
}
