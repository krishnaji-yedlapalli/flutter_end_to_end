

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin HelperWidget {

 Widget buildTitleWithContent({required String title,required Widget content}) {
    return Builder(
      builder: (context) {
        return Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            content,
            SizedBox(width : 150, child: Divider())
          ],
        );
      }
    );
  }

  Widget get vDivider => const SizedBox(height: 100, child: VerticalDivider());
}