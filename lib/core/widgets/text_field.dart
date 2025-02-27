

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {

  const CustomTextField({Key? key, required this.controller, required this.label, this.suffixIcon, this.validator, this.inputFormatter, this.prefix, this.maxLines, this.onChange}) : super(key: key);

  final TextEditingController controller;

  final String label;

  final Widget? suffixIcon;

  final String? prefix;

  final String? Function(String?)? validator;

  final List<TextInputFormatter>? inputFormatter;

  final int? maxLines;

  final ValueChanged<String?>? onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: outlineDecoration(),
      validator: validator,
      inputFormatters: inputFormatter,
      maxLines: maxLines,
      onChanged: onChange,
    );
  }

  InputDecoration outlineDecoration() {
    return InputDecoration(
      label: Text(label),
      suffixIcon: suffixIcon,
      prefixText: prefix,
      border: const OutlineInputBorder()
    );
  }
}
