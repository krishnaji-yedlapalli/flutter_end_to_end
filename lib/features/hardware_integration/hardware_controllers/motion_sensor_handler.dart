
import 'dart:async';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:sample_latest/features/hardware_integration/gpio/gpio_service.dart';

class MotionSensorHandler {
  final GpioService _gpioService;
  final int _pinNumber;
  StreamSubscription<bool>? _subscription;
  final _motionDetectedController = StreamController<bool>.broadcast();

  MotionSensorHandler(this._gpioService, this._pinNumber) {
    _initializeSensor();
  }

  void _initializeSensor() {
    // Open the pin as input
    _gpioService.openGpio(_pinNumber, GPIOdirection.gpioDirIn);

    // Listen for changes on the pin
    _subscription = _gpioService.listenToPin(_pinNumber).listen((isDetected) {
      _motionDetectedController.add(isDetected);
    });
  }

  /// Stream that emits true when motion is detected, and false when it clears.
  Stream<bool> get motionDetected => _motionDetectedController.stream;

  /// Disposes resources used by the motion sensor handler.
  void dispose() {
    _subscription?.cancel();
    _motionDetectedController.close();
    _gpioService.closeGpio(_pinNumber);
  }
}
