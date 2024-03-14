import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/utils/device_configurations.dart';

mixin CustomDialogs {
  void adaptiveDialog(BuildContext context, Widget content) {
    showAdaptiveDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: SizedBox(
            width: DeviceConfiguration.isMobileResolution
                ? null
                : MediaQuery.of(context).size.width / 3,
            child: content,
          ));
        });
  }

  Widget dialogWithButtons(
      {required String title,
      required Widget content,
      required List<String> actions,
      required ValueChanged<int> callBack}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          child: Text(title),
        ),
        const Divider(),
        content,
        const Divider(),
        _buildButtons(actions, callBack)
      ],
    );
  }

  Widget _buildButtons(List<String> actions, ValueChanged<int> callBack) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            spacing: 10,
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: List.generate(
                actions.length,
                (index) => ElevatedButton(
                    onPressed: () => callBack(index),
                    child: Text(actions.elementAt(index)))),
          ),
        ));
  }

  Future<bool?> buildAlertDialog(BuildContext context, {required String title, required String content}) async {
    showAdaptiveDialog(barrierDismissible: true,
       context: context,
       builder: (context) {
         return CupertinoAlertDialog(
       title: Text(title),
       content: Text(content),
       actions: [
         IconButton(onPressed: () => GoRouter.of(context).pop(), icon: const Icon(Icons.thumb_up))
       ],
     );
   });
  }
}
