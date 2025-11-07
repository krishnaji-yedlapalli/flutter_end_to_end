import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/shared/widgets/responsive_widgets/widgets.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.label,
      this.suffixIcon,
      this.validator,
      this.inputFormatter,
      this.prefix,
      this.maxLines,
      this.onChange})
      : super(key: key);

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
      style: TextStyle(fontSize: DeviceConfiguration.getResponsiveFontSize(14)),
      decoration: outlineDecoration(),
      validator: validator,
      inputFormatters: inputFormatter,
      maxLines: maxLines,
      onChanged: onChange,
    );
  }

  InputDecoration outlineDecoration() {
    return InputDecoration(
        label: ResponsiveText(label),
        contentPadding: DeviceConfiguration.getResponsivePadding(
            horizontal: 12, vertical: 8),
        suffixIcon: suffixIcon != null
            ? IconTheme(
                data: IconThemeData(
                  size: DeviceConfiguration.getResponsiveIconSize(24),
                ),
                child: suffixIcon!,
              )
            : null,
        prefixText: prefix,
        border: const OutlineInputBorder());
  }
}
