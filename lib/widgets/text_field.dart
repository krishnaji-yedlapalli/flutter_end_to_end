

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {

  const CustomTextField({Key? key, required this.controller, required this.label, this.suffixIcon, this.validator, this.inputFormatter}) : super(key: key);

  final TextEditingController controller;

  final String label;

  final Icon? suffixIcon;

  final String? Function(String?)? validator;

  final List<TextInputFormatter>? inputFormatter;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: outlineDecoration(),
      validator: validator,
      inputFormatters: inputFormatter,
    );
  }

  InputDecoration outlineDecoration() {
    return InputDecoration(
      label: Text(label),
      suffixIcon: suffixIcon,
      border: const OutlineInputBorder()
    );
  }
}
