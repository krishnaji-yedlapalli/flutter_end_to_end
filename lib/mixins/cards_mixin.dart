
import 'package:flutter/material.dart';

mixin CardWidgetsMixin {

  Widget buildHomeCardView({required String title, required String des, required IconData icon, VoidCallback? callback}) {
    return Builder(
      builder: (context) {
        return Card(
          child: InkWell(
            onTap: callback,
            customBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.topLeft,
                // decoration: const BoxDecoration(
                //   borderRadius: BorderRadius.all(Radius.circular(4))
                // gradient:
                // LinearGradient(colors: [
                //   Color(0xFF4B72EF),
                //   Color(0xFF00CCFF),
                // ],
                // begin: Alignment.bottomLeft ?? FractionalOffset(-1, 1.0),
                // end: Alignment.topRight ?? FractionalOffset(1, -1),
                // stops: [0.4, 0.7],
                // tileMode: TileMode.repeated,
                // // tileMode: TileMode.clamp
                // )

                // RadialGradient(colors: [
                //     Color(0xFF4B72EF),
                //     Color(0xFF00CCFF),
                // ],
                // radius: 0.7,
                // focal: Alignment(0.7, 0.7),
                // stops: [0.2, .7]
                // )
                // ),
                child: Wrap(
                  runSpacing: 3,
                  children: [
                    Row(
                      children: [
                        Icon(icon),
                      ],
                    ),
                    RichText(
                      text: TextSpan(text: 'Title : ',
                          style:  Theme.of(context).textTheme.titleSmall,
                          children: [TextSpan(text: title, style: Theme.of(context).textTheme.bodyMedium)]),
                    ),
                    RichText(softWrap: true, text: TextSpan(text: 'Des : ',
                        style:  Theme.of(context).textTheme.titleSmall,
                        children: [TextSpan(text: des, style: Theme.of(context).textTheme.bodyMedium)]),)
                  ],
                )),
          ),
        );
      }
    );
  }

}