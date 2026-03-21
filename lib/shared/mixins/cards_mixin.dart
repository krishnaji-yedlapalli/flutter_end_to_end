import 'package:flutter/material.dart';
import 'package:sample_latest/core/constants/responsive_constants.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';

mixin CardWidgetsMixin {
  Widget buildHomeCardView(
      {Key? key,
      required String title,
      required String des,
      required IconData icon,
      VoidCallback? callback}) {
    return Builder(builder: (context) {
      return Card(
        child: InkWell(
          key: key,
          onTap: callback,
          customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(
                  DeviceConfiguration.getResponsiveSpacing(
                      ResponsiveConstants.cardPadding)))),
          child: Container(
              padding: DeviceConfiguration.getResponsivePadding(
                  base: ResponsiveConstants.cardPadding),
              alignment: Alignment.topLeft,
              child: Wrap(
                runSpacing: DeviceConfiguration.getResponsiveSpacing(
                    ResponsiveConstants.tinySpacing),
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        size: DeviceConfiguration.getResponsiveIconSize(
                            ResponsiveConstants.mediumIconSize),
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Title : ',
                        style: Theme.of(context).textTheme.titleSmall,
                        children: [
                          TextSpan(
                              text: title,
                              style: Theme.of(context).textTheme.bodySmall)
                        ]),
                  ),
                  RichText(
                    softWrap: true,
                    text: TextSpan(
                        text: 'Des : ',
                        style: Theme.of(context).textTheme.titleSmall,
                        children: [
                          TextSpan(
                              text: des,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.apply(overflow: TextOverflow.ellipsis))
                        ]),
                  )
                ],
              )),
        ),
      );
    });
  }
}
