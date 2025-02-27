

import 'package:flutter/services.dart';

mixin Validators {

  static final TextInputFormatter onlyNumerics =  FilteringTextInputFormatter.allow(RegExp('[0-9]'));

      String? textEmptyValidator(String? value, String message) {
    if(value == null || value.trim().isEmpty){
      return message;
    }
    return null;
  }
}