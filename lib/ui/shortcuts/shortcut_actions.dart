

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShortcutActions extends StatelessWidget {
   ShortcutActions({Key? key}) : super(key: key);

  final controller = TextEditingController(text: 'Hello world');

  @override
  Widget build(BuildContext context) {
    // return Container();
    return Shortcuts(shortcuts: <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyC) :  const ClearAllIntent(),
    }, child: Actions(
      // dispatcher: LoggingActionDispatcher(),
      actions: <Type, Action<Intent>>{
        ClearAllIntent : ClearAllAction(controller)
      },
      child:  Focus(
        autofocus: true,
        child: Text('dfsd') ??  TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            icon: IconButton(onPressed: () => Actions.handler<ClearAllIntent>(context, const ClearAllIntent()), icon: const Icon(Icons.clear))
          ),
        ),
      ),
    ));
  }
}


class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    final KeyEventResult result = super.handleKeypress(context, event);
    if (result == KeyEventResult.handled) {
      print('Handled shortcut $event in $context');
    }
    return result;
  }
}

class ClearAllIntent extends Intent {
  const ClearAllIntent();
}

class ClearAllAction extends Action<ClearAllIntent> {

  ClearAllAction(this.controller);

  final TextEditingController controller;

  @override
  void invoke(covariant ClearAllIntent intent) {
    controller.clear();
  }
}
