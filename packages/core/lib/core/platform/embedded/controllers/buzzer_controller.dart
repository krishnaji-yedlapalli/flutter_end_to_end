import 'dart:async';

import 'package:app_core/core/platform/embedded/services/gpio_service.dart';
import 'package:dart_periphery/dart_periphery.dart';

class BuzzerController {
  final GpioService _gpioService;
  final int _pinNumber;

  BuzzerController(this._gpioService, this._pinNumber) {
    // Open the pin as output
    _gpioService.openGpio(_pinNumber, GPIOdirection.gpioDirOut);
  }

  /// Turns the buzzer on.
  bool turnOn() {
    return _gpioService.writePin(_pinNumber, true);
  }

  /// Turns the buzzer off.
  bool turnOff() {
    return _gpioService.writePin(_pinNumber, false);
  }

  /// Makes the buzzer beep for a short duration.
  Future<void> beep(
      {Duration duration = const Duration(milliseconds: 200)}) async {
    turnOn();
    await Future.delayed(duration);
    turnOff();
  }

  /// Disposes resources used by the buzzer controller.
  void dispose() {
    _gpioService.closeGpio(_pinNumber);
  }
}
