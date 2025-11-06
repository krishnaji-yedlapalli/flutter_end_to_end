import 'dart:async';
import 'package:dart_periphery/dart_periphery.dart';

class GpioService {
  final Map<int, GPIO> _openGpios = {};
  final Map<int, StreamController<bool>> _pinStreamControllers = {};

  /// Opens a GPIO pin and sets its direction.
  /// Returns the Gpio instance if successful, null otherwise.
  GPIO? openGpio(int pinNumber, GPIOdirection direction) {
    if (_openGpios.containsKey(pinNumber)) {
      // Pin already open, return existing instance
      return _openGpios[pinNumber];
    }
    try {
      final gpio = GPIO(pinNumber, direction);
      _openGpios[pinNumber] = gpio;
      return gpio;
    } catch (e) {
      print('Error opening GPIO pin $pinNumber: $e');
      return null;
    }
  }

  /// Closes a specific GPIO pin.
  void closeGpio(int pinNumber) {
    _openGpios[pinNumber]?.dispose();
    _openGpios.remove(pinNumber);
    _pinStreamControllers[pinNumber]?.close();
    _pinStreamControllers.remove(pinNumber);
  }

  /// Writes a value to an output GPIO pin.
  /// Returns true if successful, false otherwise.
  bool writePin(int pinNumber, bool value) {
    final gpio = _openGpios[pinNumber];
    if (gpio == null) {
      print('GPIO pin $pinNumber is not open.');
      return false;
    }
    try {
      gpio.write(value);
      return true;
    } catch (e) {
      print('Error writing to GPIO pin $pinNumber: $e');
      return false;
    }
  }

  /// Reads the current value of a GPIO pin.
  /// Returns the GpioValue if successful, null otherwise.
  bool? readPin(int pinNumber) {
    final gpio = _openGpios[pinNumber];
    if (gpio == null) {
      print('GPIO pin $pinNumber is not open.');
      return null;
    }
    try {
      return gpio.read();
    } catch (e) {
      print('Error reading from GPIO pin $pinNumber: $e');
      return null;
    }
  }

  /// Provides a stream for changes on an input GPIO pin.
  /// The pin must be opened as input with `openGpio` before listening.
  Stream<bool> listenToPin(int pinNumber) {
    if (!_pinStreamControllers.containsKey(pinNumber)) {
      final gpio = _openGpios[pinNumber];
      if (gpio == null || gpio.getGPIOdirection() != GPIOdirection.gpioDirIn) {
        throw Exception(
            'GPIO pin $pinNumber must be opened as input before listening.');
      }
      final controller = StreamController<bool>.broadcast();
      _pinStreamControllers[pinNumber] = controller;

      // Listen for both rising and falling edges for general detection
      // fin res = gpio.getHandle()
      // gpio.readEvent((_) => controller.add(true));
      // gpio.onFalling((_) => controller.add(false));
    }
    return _pinStreamControllers[pinNumber]!.stream;
  }

  /// Disposes all open GPIO pins and stream controllers.
  void dispose() {
    _openGpios.forEach((pin, gpio) => gpio.dispose());
    _openGpios.clear();
    _pinStreamControllers.forEach((pin, controller) => controller.close());
    _pinStreamControllers.clear();
  }
}
