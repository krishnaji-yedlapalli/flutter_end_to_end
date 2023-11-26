import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample_latest/mixins/helper_widgets_mixin.dart';

class CallBackShortCutsView extends StatefulWidget {
  const CallBackShortCutsView({Key? key}) : super(key: key);

  @override
  State<CallBackShortCutsView> createState() => _CallBackShortCutsViewState();
}

class _CallBackShortCutsViewState extends State<CallBackShortCutsView> with HelperWidget{
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
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 10,
                  children: [
                    Text('We can control the below count using below keyboard shortcuts : ', style: Theme.of(context).textTheme.titleSmall),
                    SizedBox(height: 10),
                    iconWithText('Up Arrow', Icons.arrow_upward_outlined, 'Increment the value'),
                    iconWithText('Down Arrow', Icons.arrow_downward, 'Decrement the value'),
                    iconWithText('Ctrl + delete/backspace', Icons.clear, 'Reset the value to Zero')
                  ],
                ),
              ),
            ),
            Expanded(
              child: Focus(
                autofocus: true,
                canRequestFocus: true,
                child: Container(alignment: Alignment.topCenter,
                    child: Text('Count : $i', style: Theme.of(context).textTheme.displaySmall)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

(int a, int b, int c) func() {
  return (1, 2, 3);
}
