

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

mixin HelperWidget {

 Widget buildTitleWithContent({required String title,required Widget content, bool hideBorder = false}) {
    return Builder(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: content,
            ),
           if(!DeviceConfiguration.isMobileResolution && !hideBorder) SizedBox(width : 150, child: Divider())
          ],
        );
      }
    );
  }

 Widget buildTitleWithExpandedContent({required String title,required Widget content, bool hideBorder = false}) {
   return Builder(
       builder: (context) {
         return Padding(
           padding: const EdgeInsets.all(8.0),
           child: Column(
             mainAxisSize: MainAxisSize.min,
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Text(title, style: Theme.of(context).textTheme.titleMedium),
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.symmetric(vertical: 16.0),
                   child: content,
                 ),
               ),
               if(!DeviceConfiguration.isMobileResolution && !hideBorder) SizedBox(width : 150, child: Divider())
             ],
           ),
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

 Widget buildLabelWithValue(String label, String value, {String? des, bool isBorderRequired = false}) {
   return LayoutBuilder(
     builder: (context, constraints) {
       double maxWidth = DeviceConfiguration.isMobileResolution ? constraints.maxWidth : constraints.maxWidth;
       return Container(
           constraints: BoxConstraints(
             maxWidth: maxWidth
           ),
           decoration: isBorderRequired ? const BoxDecoration(
             border :Border(bottom: BorderSide(color: Colors.grey))
           ) : null,
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
                   text: '${AppLocalizations.of(context)!.description} :',
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

 Widget buildNote(String note) {
   return Builder(
     builder: (context) {
       return Padding(
         padding: const EdgeInsets.symmetric(vertical: 12),
         child: RichText(text: TextSpan(
           text: 'Note : ',
           style: Theme.of(context).textTheme.titleMedium?.apply(color: Colors.red),
           children: [
             TextSpan(text: note, style: Theme.of(context).textTheme.bodyMedium)
           ]
         )),
       );
     }
   );
 }

 Widget get buildUnderDevelopmentMessage => Builder(
   builder: (context) {
     return Align(alignment: Alignment.center, child: Text('Currently under development', style: Theme.of(context).textTheme.displaySmall?.apply(color: Colors.orange)));
   }
 );

 Widget emptyMessage(String message) => Builder(
   builder: (context) {
     return Container(
       padding: const EdgeInsets.all(8.0),
         alignment: Alignment.center,
         child: Text(message, style: Theme.of(context).textTheme.labelLarge),
     );
   }
 );

}