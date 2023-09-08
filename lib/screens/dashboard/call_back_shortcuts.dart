import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CallBackShortCutsView extends StatefulWidget {
  const CallBackShortCutsView({Key? key}) : super(key: key);

  @override
  State<CallBackShortCutsView> createState() => _CallBackShortCutsViewState();
}

class _CallBackShortCutsViewState extends State<CallBackShortCutsView> {
  var i = 0;
  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <SingleActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.arrowUp): () {
          setState(() {
            i++;
          });
        },
        const SingleActivator(LogicalKeyboardKey.arrowDown): () {
          setState(() {
            i--;
          });
        },
        const SingleActivator(LogicalKeyboardKey.backspace, control: true): () {
          setState(() {
            i = 0;
          });
        },
      },
      child: CallbackShortcuts(
        bindings: <CharacterActivator, VoidCallback> {
          const CharacterActivator('c', control: true): () {
            setState(() {
              i = 0;
            });
          }
        },
        child: Focus(
          autofocus: true,
          child: Container(alignment: Alignment.center, child: Text('value : $i')),
        ),
      ),
    );
  }
}

(int a, int b, int c) func() {
  return (1, 2, 3);
}
