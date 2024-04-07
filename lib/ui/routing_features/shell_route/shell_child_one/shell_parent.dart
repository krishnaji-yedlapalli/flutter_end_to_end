import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_latest/extensions/widget_extension.dart';
import 'package:sample_latest/provider/route_provider.dart';
import 'package:sample_latest/routing.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

class ShellChildOne extends StatelessWidget {
  const ShellChildOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Parent Shell Route ${context.watch<RouteProvider>().value}', style: Theme.of(context).textTheme.displaySmall),
            const Text(
              'This parent shell route having three child routes and for these three child routes app bar is same, only body will changes.\n',
              textAlign: TextAlign.center,
            ),
            const Text('Whole shell route is using provider state management tool, For this we are going to use RouteProvider class for managing the count value as shown below \n'),
            const Text('Here one of the advantage is, to declare the provider no need to wrap it around Material/Cupertino simply we can wrap it in parent shell provider as implemented here.\n'),
            Wrap(
              spacing: 5,
              children: [
                IconButton.filledTonal(onPressed: context.read<RouteProvider>().decrease, icon: Icon(Icons.remove)),
                Text('${context.watch<RouteProvider>().value}', style: Theme.of(context).textTheme.displaySmall),
                IconButton.filledTonal(onPressed: context.read<RouteProvider>().increase, icon: Icon(Icons.add)),
              ],
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(text: 'Note: ', style: TextStyle(color: Colors.red)),
              TextSpan(text: 'Except for web, if you use Device/App back navigation, it will pop entire shell this needs to be handle using back button dispatcher currently working on it \n', style: TextStyle(color: Colors.black)),
            ])),
            ElevatedButton(onPressed: () => onTap(context), child: const Text('Navigate to Child one'))
          ],
        ).screenPadding();
  }

  void onTap(BuildContext context) {
    var query = {'id': 123};
    context.go(
      '/home/route/parent/child1',
    );
  }
}
