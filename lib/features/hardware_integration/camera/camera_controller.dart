import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter_lite_camera/flutter_lite_camera.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class CameraController {
  static final CameraController _instance = CameraController._internal();
  factory CameraController() => _instance;
  CameraController._internal();

  final FlutterLiteCamera _cameraPlugin = FlutterLiteCamera();
  bool _isCameraOpened = false;
  bool _isCapturing = false;
  int _width = 640;
  int _height = 480;
  late GPIO _gpio;
  String _buttonState = 'Unknown';
  String? _lastCapturedPath;

// Register singleton
  static void registerSingleton() {
    getIt.registerSingleton<CameraController>(CameraController());
  }

// Initialize camera and GPIO
  Future<void> initialize() async {
// Set c-periphery library path
    setCustomLibrary('/usr/local/lib/libperiphery.so');

// Initialize camera
    try {
      List<String> devices = await _cameraPlugin.getDeviceList();
      if (devices.isEmpty) {
        throw Exception('No camera devices found');
      }
      print('Available Devices: $devices');
      bool opened = await _cameraPlugin.open(0); // Open first camera
      if (!opened) {
        throw Exception('Failed to open camera');
      }
      _isCameraOpened = true;
      _isCapturing = true;
      print('Camera initialized');
    } catch (e) {
      print('Error initializing camera: $e');
      _isCameraOpened = false;
      _isCapturing = false;
    }

// Initialize GPIO 17 for button input
    try {
      var config = GPIOconfig(
        GPIOdirection.gpioDirIn,
        GPIOedge.gpioEdgeFalling, // Detect button press (high to low)
        GPIObias.gpioBiasPullUp, // Pull-up for button to ground
        GPIOdrive.gpioDriveDefault,
        false,
        'button_pin_17',
      );
      _gpio = GPIO.advanced(17, config);
      _listenForButtonPress();
    } catch (e) {
      print('Error initializing GPIO: $e');
    }
  }

// Listen for button press to trigger capture
  void _listenForButtonPress() async {
    try {
      while (_isCameraOpened) {
        if (_gpio.poll(-1) == GPIOpolling.success) {
          bool state = _gpio.read();
          _buttonState = state ? 'Released (High)' : 'Pressed (Low)';
          print('GPIO 17 state: $_buttonState');
          if (!state) {
            // Button pressed
            await captureAndSaveFrame();
          }
        }
      }
    } catch (e) {
      print('GPIO polling error: $e');
    }
  }

// Capture a single frame
  Future<Uint8List?> captureFrame() async {
    if (!_isCameraOpened || !_isCapturing) {
      print('Camera not opened or capturing stopped');
      return null;
    }
    try {
      Map<String, dynamic> frame = await _cameraPlugin.captureFrame();
      if (frame.containsKey('data')) {
        _width = frame['width'];
        _height = frame['height'];
        return frame['data'] as Uint8List;
      }
      return null;
    } catch (e) {
      print('Error capturing frame: $e');
      return null;
    }
  }

// Capture and save frame to storage
  Future<String?> captureAndSaveFrame() async {
    try {
      Uint8List? rgbBuffer = await captureFrame();
      if (rgbBuffer == null) {
        print('No frame captured');
        return null;
      }
      final directory = await getTemporaryDirectory();
      final path =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.raw';
      await File(path).writeAsBytes(rgbBuffer);
      _lastCapturedPath = path;
      print('Frame saved to: $path');
      return path;
    } catch (e) {
      print('Error saving frame: $e');
      return null;
    }
  }

// Get button state
  String getButtonState() => _buttonState;

// Get last captured frame path
  String? getLastCapturedPath() => _lastCapturedPath;

// Stop capturing
  void stopCapturing() {
    _isCapturing = false;
    print('Stopped capturing frames');
  }

// Dispose resources
  void dispose() {
    _isCapturing = false;
    if (_isCameraOpened) {
// _cameraPlugin.();
      _isCameraOpened = false;
      print('Camera closed');
    }
    _gpio.dispose();
    print('GPIO disposed');
  }
}
