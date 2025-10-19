import 'package:sample_latest/features/hardware_integration/hardware_controllers/buzzer_controller.dart';
import 'package:sample_latest/features/hardware_integration/hardware_controllers/motion_sensor_handler.dart';
import 'package:sample_latest/features/hardware_integration/camera/camera_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_latest/features/hardware_integration/gpio/gpio_service.dart';

class HardwareInjectionModule {
  HardwareInjectionModule._();

  static final HardwareInjectionModule _instance = HardwareInjectionModule._();

  factory HardwareInjectionModule() => _instance;

  final GetIt injector = GetIt.instance;

  void registerDependencies() {
    if (!injector.isRegistered<GpioService>()) {
      injector.registerSingleton<GpioService>(GpioService());
    }
    if (!injector.isRegistered<CameraController>()) {
      injector
          .registerLazySingleton<CameraController>(() => CameraController());
    }
    // Register hardware controllers as factories, requiring pin numbers
    injector.registerFactoryParam<MotionSensorHandler, int, void>(
        (pinNumber, _) =>
            MotionSensorHandler(injector<GpioService>(), pinNumber));
    injector.registerFactoryParam<BuzzerController, int, void>(
        (pinNumber, _) => BuzzerController(injector<GpioService>(), pinNumber));
  }

  void unRegisterDependencies() {
    if (injector.isRegistered<GpioService>()) {
      injector.unregister<GpioService>();
    }
    if (injector.isRegistered<CameraController>()) {
      injector.unregister<CameraController>();
    }
    // No need to unregister factories, as they are created on demand.
    // However, ensure their dispose methods are called if they manage resources.
    // For MotionSensorHandler and BuzzerController, their dispose methods
    // should be called by the consumer when they are no longer needed.
  }
}
