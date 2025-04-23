import 'package:flutter/material.dart';

class AppConfiguration {
  final String appBarLogoPath;

  final Color seedColor;

  final Color? hoverColor;

  AppConfiguration(
      {required this.appBarLogoPath,
      this.seedColor = Colors.green,
      this.hoverColor});
}
