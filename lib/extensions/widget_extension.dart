
import 'package:flutter/material.dart';

extension WidgetExtension on Widget {

  Padding screenPadding() {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    child: this,
    );
  }
}