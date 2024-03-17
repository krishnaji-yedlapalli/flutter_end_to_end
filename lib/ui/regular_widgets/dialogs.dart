import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/extensions/widget_extension.dart';

enum DialogType { fullscreen, alertDialog, simpleDialog, simpleDialogOption }

class Dialogs extends StatelessWidget {
  const Dialogs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // spacing: 10,
      // runSpacing: 20,
      // direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () =>
                showDialogBasedOnType(context, DialogType.fullscreen),
            child: const Text('Full Screen Dialog')),
        ElevatedButton(
            onPressed: () =>
                showDialogBasedOnType(context, DialogType.alertDialog),
            child: const Text('Alert Screen Dialog')),
        ElevatedButton(
            onPressed: () =>
                showDialogBasedOnType(context, DialogType.simpleDialog),
            child: const Text('Simple Screen Dialog')),
        ElevatedButton(
          onPressed: () =>
              showDialogBasedOnType(context, DialogType.simpleDialogOption),
          child: Text('Simple Dialog Option'),
        )
      ],
    ).screenPadding();
  }

  void showDialogBasedOnType(BuildContext context, DialogType type) {
    late Widget dialog;

    dialog = switch (type) {
      DialogType.fullscreen => fullScreenDialog(),
      DialogType.alertDialog => alertDialog(context),
      DialogType.simpleDialog => simpleDialog(context),
      DialogType.simpleDialogOption => simpleDialogWithOptions(context),
      _ => dialog = Container()
    };

    showDialog(
        // useRootNavigator: type == DialogType.fullscreen ? true : false,
        context: context,
        builder: (context) => dialog);
  }

  Widget fullScreenDialog() {
    return Builder(
      builder: (context) {
        return Dialog.fullscreen(
             insetAnimationCurve: Curves.bounceIn,
            insetAnimationDuration: Duration(seconds: 3),
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Text('Full Screen Dialog', style: Theme.of(context).textTheme.headlineMedium?.apply(color: Colors.purple)),
                IconButton(onPressed: () =>  GoRouter.of(context).pop(), icon: Icon(Icons.close, size: 30, color: Colors.red))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(),
            ),
            sampleText,
            Expanded(child: FlutterLogo(size: 200)),
            sampleText
          ],
        ).screenPadding());
      }
    );
  }

  Widget alertDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Alert Dialog'),
      content: sampleText,
      actions: [
        IconButton(onPressed: () => navigator(context), icon: Icon(Icons.close))
      ],
      // insetPadding: ,
    );
  }

  Widget simpleDialog(BuildContext context) {
    return SimpleDialog(
      title: Text('Simple Dialog'),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      // insetPadding:  EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      children: sampleText.children
    );
  }

  Widget simpleDialogWithOptions(BuildContext context) {
    return SimpleDialogOption(
      child: Text(
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dumm"),
    );
  }

  Wrap get sampleText => const Wrap(
    spacing: 10,
    children: [
      Text(
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dumm"),
      Text(
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dumm"),
      Text(
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dumm")
    ],
  );

  void navigator(BuildContext context) {
    GoRouter.of(context).pop();
  }
}
