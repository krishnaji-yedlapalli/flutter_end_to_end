

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

 Widget iconWithText(String label, IconData icon, String des) {
   return Builder(
     builder: (context) {
       return Wrap(
         runSpacing: 5,
         crossAxisAlignment: WrapCrossAlignment.center,
         alignment: WrapAlignment.center,
         children: [
           Text(label, style: Theme.of(context).textTheme.labelLarge?.apply(fontWeightDelta: 100)),
           Icon(icon, weight: 600),
           Text(' :  $des')
         ],
       );
     }
   );
 }

  Widget get vDivider => const SizedBox(height: 100, child: VerticalDivider());
}