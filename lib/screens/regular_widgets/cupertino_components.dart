
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_latest/mixins/helper_widgets_mixin.dart';

class CupertinoComponents extends StatefulWidget {
  const CupertinoComponents({Key? key}) : super(key: key);

  @override
  State<CupertinoComponents> createState() => _CupertinoComponentsState();
}

class _CupertinoComponentsState extends State<CupertinoComponents> with HelperWidget  {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Wrap(
          spacing: 50,
          runSpacing: 50,
          children: [
            _buildActivityIndicator(),
            vDivider,
            _buildCupertinoAlertDialog()
          ],
        ),
      ),
    );
  }

  Widget _buildActivityIndicator() {
    return buildTitleWithContent(
      title: 'Cupertino Activity Indicator',
      content:CupertinoActivityIndicator(),
    );
  }

  Widget _buildCupertinoAlertDialog() {
    return buildTitleWithContent(
      title: 'Cupertino Alert Dialog',
      content: CupertinoButton(child: const Text('Alert Dialog'), onPressed: _showAlertDialog),
    );
  }

  void _showAlertDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('Proceed with destructive action?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
