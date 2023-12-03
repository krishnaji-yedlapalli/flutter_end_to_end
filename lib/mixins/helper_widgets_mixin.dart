

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_latest/utils/device_configurations.dart';

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

  Widget get hDivider => const SizedBox(width: 100, child: Divider());

 Widget buildLabelWithValue(String label, String value, {String? des}) {
   return LayoutBuilder(
     builder: (context, constraints) {
       double maxWidth = DeviceConfiguration.isMobileResolution ? constraints.maxWidth : 400;
       return Container(
           constraints: BoxConstraints(
             maxWidth: maxWidth
           ),
           padding: EdgeInsets.only(bottom: 16),
           decoration: const BoxDecoration(
             border :Border(bottom: BorderSide(color: Colors.grey))
           ),
           child: Wrap(
             direction: Axis.vertical,
             spacing: 10,
             children: [
               Text('$label : ', style: Theme.of(context).textTheme.labelLarge?.apply(fontWeightDelta: 100),softWrap: true),
               if(des != null) Container(
                 constraints: BoxConstraints(maxWidth: maxWidth),
                 child: RichText(
                     softWrap: true,
                     text: TextSpan(
                   text: 'Des : ',
                  style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.black),
                  children: [
                    TextSpan(
                      text: des,
                      style: Theme.of(context).textTheme.bodySmall
                    )
                  ]
                 )),
               ),
               Text('$value', style: TextStyle(backgroundColor: Colors.grey.shade200)),
             ],
           ),
       );
     }
   );
 }
}