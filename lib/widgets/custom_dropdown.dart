
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
      style: TextStyle(fontWeight: FontWeight.w100),
      decoration: const InputDecoration(
        border: OutlineInputBorder()
      ),
    );
  }
}
