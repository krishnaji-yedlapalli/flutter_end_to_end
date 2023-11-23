

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
   double maxWidth = DeviceConfiguration.isMobileResolution ? double.infinity : 300;
   return Builder(
     builder: (context) {
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
             Text('$label : ', style: Theme.of(context).textTheme.labelLarge?.apply(fontWeightDelta: 100)),
             if(des != null) Container(
               constraints: BoxConstraints(maxWidth: maxWidth),
               child: RichText(
                   softWrap: true,
                   text: TextSpan(
                 text: 'Des : ',
                style: TextStyle(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: des,
                    style: TextStyle(
                        fontWeight: FontWeight.w100
                    )
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