

import 'package:flutter/material.dart';

class RouteProvider with ChangeNotifier {


  int value = 0;

  void increase() {
    value++;
    notifyListeners();
  }

  void decrease() {
    value--;
    notifyListeners();
  }
}