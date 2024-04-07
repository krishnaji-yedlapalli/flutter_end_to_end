
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sample_latest/provider/route_provider.dart';

class ShellChildOneChildThree extends StatelessWidget {
  const ShellChildOneChildThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Wrap(
            spacing: 5,
            children: [
              IconButton.filledTonal(onPressed: context.read<RouteProvider>().decrease, icon: Icon(Icons.remove)),
              Text('${context.watch<RouteProvider>().value}', style: Theme.of(context).textTheme.displaySmall),
              IconButton.filledTonal(onPressed: context.read<RouteProvider>().increase, icon: Icon(Icons.add)),
            ],
          ),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('pop'))
        ],
      ),
    );
  }
}