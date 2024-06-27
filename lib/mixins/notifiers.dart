
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

mixin Notifiers {

  static void toastNotifier(String label) {

    Fluttertoast.showToast(
        msg: label,
        webShowClose: true,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        // webBgColor: Colors.grey,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}