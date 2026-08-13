import 'package:flutter/material.dart';

mixin ButtonMixin {
  Widget customTextButton({required String label, VoidCallback? callback}) {
    return Builder(builder: (context) {
      return TextButton(
        onPressed: callback,
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.orange;
              } else {
                return Colors.lightGreen;
              }
            }),
            shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))))),
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Colors.white),
        ),
      );
    });
  }
}
