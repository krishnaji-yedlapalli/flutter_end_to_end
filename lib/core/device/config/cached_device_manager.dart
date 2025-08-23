import 'package:flutter/material.dart';
import 'device_configurations.dart';

/// Manager class that handles device configuration updates efficiently
class CachedDeviceManager {
  static final CachedDeviceManager _instance = CachedDeviceManager._internal();
  factory CachedDeviceManager() => _instance;
  CachedDeviceManager._internal();

  // Listeners for device type changes
  final List<VoidCallback> _listeners = [];

  /// Add listener for device type changes
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// Remove listener
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Update device configuration and notify listeners only if changed
  void updateConfiguration(Size size, Orientation orientation, [double? pixelRatio]) {
    bool hasChanged = DeviceConfiguration
        .updateDeviceResolutionAndOrientation(size, orientation, pixelRatio);
    
    if (hasChanged) {
      // Only notify listeners if device type actually changed
      for (final listener in _listeners) {
        listener();
      }
    }
  }

  /// Dispose all listeners
  void dispose() {
    _listeners.clear();
  }
}

/// Widget that efficiently manages device configuration updates
class DeviceConfigurationProvider extends StatefulWidget {
  final Widget child;

  const DeviceConfigurationProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<DeviceConfigurationProvider> createState() => 
      _DeviceConfigurationProviderState();
}

class _DeviceConfigurationProviderState 
    extends State<DeviceConfigurationProvider> 
    with WidgetsBindingObserver {
  
  final CachedDeviceManager _deviceManager = CachedDeviceManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Update configuration when device metrics change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final size = MediaQuery.of(context).size;
        final orientation = MediaQuery.of(context).orientation;
        final pixelRatio = MediaQuery.of(context).devicePixelRatio;
        _deviceManager.updateConfiguration(size, orientation, pixelRatio);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        // Initial configuration update
        final pixelRatio = MediaQuery.of(context).devicePixelRatio;
        _deviceManager.updateConfiguration(
          MediaQuery.of(context).size,
          orientation,
          pixelRatio,
        );
        
        return widget.child;
      },
    );
  }
}

/// Example usage in main.dart
/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DeviceConfigurationProvider(
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}
*/
