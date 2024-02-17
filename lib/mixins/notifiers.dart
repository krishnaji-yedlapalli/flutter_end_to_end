
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

mixin Notifiers {

  static void toastNotifier(String label) {

    Fluttertoast.showToast(
        msg: label,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}