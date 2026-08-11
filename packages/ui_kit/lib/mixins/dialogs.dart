import 'package:app_core/core/constants/responsive_constants.dart';
import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/widgets/responsive_widgets/widgets.dart';

mixin CustomDialogs {
  void adaptiveDialog(BuildContext context, Widget content,
      {bool useRootNavigator = true}) {
    showAdaptiveDialog(
        context: context,
        useRootNavigator: useRootNavigator,
        builder: (context) {
          return Dialog(
              child: SizedBox(
            width: DeviceConfiguration.isMobileResolution
                ? null
                : DeviceConfiguration.isTabResolution
                    ? MediaQuery.of(context).size.width / 2
                    : MediaQuery.of(context).size.width / 3,
            child: SingleChildScrollView(child: content),
          ));
        });
  }

  Widget dialogWithButtons(
      {required String title,
      required Widget content,
      required List<String> actions,
      required ValueChanged<int> callBack}) {
    return Builder(builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: ResponsiveConstants.smallPadding,
                vertical: ResponsiveConstants.mediumPadding),
            child: ResponsiveTitle(title),
          ),
          const Divider(),
          Flexible(fit: FlexFit.loose, child: content),
          const Divider(),
          _buildButtons(actions, callBack)
        ],
      );
    });
  }

  Widget _buildButtons(List<String> actions, ValueChanged<int> callBack) {
    return Padding(
        padding: const EdgeInsets.all(ResponsiveConstants.smallPadding),
        child: Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            spacing: 10,
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: List.generate(
                actions.length,
                (index) => AdaptiveResponsiveButton(
                    onPressed: () => callBack(index),
                    text: actions.elementAt(index))),
          ),
        ));
  }

  Future<bool?> buildAlertDialog(BuildContext context,
      {required String title, required String content}) async {
    return await showAdaptiveDialog<bool?>(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: ResponsiveTitle(title),
            content: ResponsiveText(content),
            actions: [
              IconButton(
                  onPressed: () => GoRouter.of(context).pop(true),
                  icon: const Icon(Icons.thumb_up))
            ],
          );
        });
  }

  static Future<bool> buildAlertDialogWithYesOrNo(BuildContext context,
      {required String title, required String content}) async {
    return await showAdaptiveDialog<bool>(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: ResponsiveTitle(title),
                content: ResponsiveText(content),
                actions: [
                  TextButton(
                      onPressed: () => GoRouter.of(context).pop(false),
                      child: const ResponsiveText(
                        'No',
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      )),
                  TextButton(
                      onPressed: () => GoRouter.of(context).pop(true),
                      child: const ResponsiveText(
                        'Yes',
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              );
            }) ??
        false;
  }
}
