
import 'package:flutter/material.dart';

class CustomDropDown<T> extends StatelessWidget {

  const CustomDropDown({Key? key, required this.value, required this.items, required this.onChanged, this.hint, this.validator}) : super(key: key);

  final T? value;

  final List<DropdownMenuItem<T>> items;

  final ValueChanged<T?> onChanged;

  final String? hint;

  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      hint: hint != null ? Text(hint!) : null,
      items: items, onChanged: onChanged,
      value: value,
      validator: validator,
      style: const TextStyle(fontWeight: FontWeight.w100, color: Colors.black),
      decoration: const InputDecoration(
        border: OutlineInputBorder()
      ),
    );
  }
}
