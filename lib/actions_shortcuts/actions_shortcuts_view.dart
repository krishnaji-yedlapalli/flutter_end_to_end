

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActionShortcuts extends StatefulWidget {
  const ActionShortcuts({Key? key}) : super(key: key);

  @override
  State<ActionShortcuts> createState() => _ActionShortcutsState();
}

class _ActionShortcutsState extends State<ActionShortcuts> {

  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Container();
    // return Shortcuts(
    //   shortcuts: <LogicalKeySet, Intent> {
    //    LogicalKeySet(LogicalKeyboardKey.arrowUp) : IncrementIntent(),
    //    LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA) :
    //    SelectAllIntent()
    //   },
    //   child: Actions(
    //     dispatcher: LoggingActionDispatcher(),
    //     actions: <Type, Action<Intent>> {
    //       IncrementIntent : CallbackAction<IncrementIntent>(onInvoke: (IncrementIntent intent){
    //         setState(() {
    //           i++;
    //         });
    //       }),
    //     SelectAllIntent : SelectAllAction(model)
    //     },
    //     child: Column(
    //       children: [
    //         Container(
    //           alignment: Alignment.center,
    //           child: Focus(
    //             autofocus: true,
    //               child: Text('$i')),
    //         ),
    //         GestureDetector(
    //           onTap: () {
    //
    //           },
    //           child: Text(
    //             'Hi there, how are you hope you are doing Good'
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}

class IncrementIntent extends Intent {
  const IncrementIntent();
}
class DecrementIntent extends Intent {
  const DecrementIntent();
}


class LoggingShortcutManager extends ShortcutManager {

  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    final KeyEventResult result =  super.handleKeypress(context, event);
    if(result == KeyEventResult.handled){
      print('handle system itself');
    }
    return result;
  }
}
