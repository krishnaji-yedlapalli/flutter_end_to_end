
import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {

  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}