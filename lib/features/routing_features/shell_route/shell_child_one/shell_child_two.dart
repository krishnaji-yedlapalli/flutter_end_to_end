import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sample_latest/core/presentation/provider/route_provider.dart';

class ShellChildOneChildTwo extends StatelessWidget {
  const ShellChildOneChildTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              IconButton.filledTonal(
                  onPressed: context.read<RouteProvider>().decrease,
                  icon: const Icon(Icons.remove)),
              Text('${context.watch<RouteProvider>().value}',
                  style: Theme.of(context).textTheme.displaySmall),
              IconButton.filledTonal(
                  onPressed: context.read<RouteProvider>().increase,
                  icon: const Icon(Icons.add)),
            ],
          ),
          ElevatedButton(
              onPressed: () => onTap(context),
              child: const Text('Navigate to Child 3')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: const Text('pop'))
        ],
      ),
    );
  }

  void onTap(BuildContext context) {
    // var query = {
    //   'id' : 123
    // };
    context.push(
      '/home/route/parent/child1/child2/child3',
    );
  }
}
