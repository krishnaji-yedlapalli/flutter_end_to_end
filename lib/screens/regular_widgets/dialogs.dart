
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/extensions/widget_extension.dart';

enum DialogType {fullscreen, alertDialog, simpleDialog}

class Dialogs extends StatelessWidget {
  const Dialogs({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 10,
        children: [
          ElevatedButton(onPressed: () => showDialogBasedOnType(context, DialogType.fullscreen), child: Text('Full Screen Dialog')),
          ElevatedButton(onPressed: () => showDialogBasedOnType(context, DialogType.alertDialog), child: Text('Alert Screen Dialog')),
          ElevatedButton(onPressed: () => showDialogBasedOnType(context, DialogType.simpleDialog), child: Text('Simple Screen Dialog'))
        ],
      ),
    );
  }


  void showDialogBasedOnType(BuildContext context, DialogType type) {
    late Widget dialog;

    dialog = switch(type){
       DialogType.fullscreen => fullScreenDialog(),
       DialogType.alertDialog => alertDialog(context),
       DialogType.simpleDialog => simpleDialog(context),
       _ => dialog = Container()
    };

    showDialog(
        useRootNavigator: type == DialogType.fullscreen ? true : false,
        context: context, builder: (context) =>
        dialog
    );
  }

  Widget fullScreenDialog() {
    return const Dialog.fullscreen(
      child: Column(
        children: [
          Text('Heloo'),
        ],
      )
    );
  }

  Widget alertDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Title'),
      content: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dumm"),
      actions: [
        IconButton(onPressed: () => navigator(context), icon: Icon(Icons.close))
      ],
      // insetPadding: ,
    );
  }

  Widget simpleDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Title'),
      content: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dumm"),
      actions: [
        IconButton(onPressed: () => navigator(context), icon: Icon(Icons.close))
      ],
      // insetPadding: ,
    );
  }

  void navigator(BuildContext context) {
    GoRouter.of(context).pop();
  }
}
