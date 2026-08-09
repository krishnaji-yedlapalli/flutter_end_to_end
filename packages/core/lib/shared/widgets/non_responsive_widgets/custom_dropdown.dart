import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/shared/widgets/responsive_widgets/widgets.dart';
import 'package:flutter/material.dart';

class CustomDropDown<T> extends StatelessWidget {
  const CustomDropDown(
      {Key? key,
      required this.value,
      required this.items,
      required this.onChanged,
      this.hint,
      this.validator})
      : super(key: key);

  final T? value;

  final List<DropdownMenuItem<T>> items;

  final ValueChanged<T?> onChanged;

  final String? hint;

  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      hint: hint != null ? ResponsiveText(hint!) : null,
      items: items,
      onChanged: onChanged,
      initialValue: value,
      validator: validator,
      style: TextStyle(
          fontSize: DeviceConfiguration.getResponsiveFontSize(14),
          fontWeight: FontWeight.w100,
          color: Colors.black),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: DeviceConfiguration.getResponsivePadding(
            horizontal: 12, vertical: 12),
      ),
    );
  }
}
