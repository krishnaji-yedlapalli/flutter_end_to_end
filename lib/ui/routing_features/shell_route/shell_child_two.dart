
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sample_latest/provider/route_provider.dart';

class ShellChildTwo extends StatelessWidget {
  const ShellChildTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        runSpacing: 10,
        children: [
          Text('Child one ${context.read<RouteProvider>().value}', style: Theme.of(context).textTheme.displayLarge),
          ElevatedButton(onPressed: () => context.push('/home/route/child3'), child: const Text('Navigate to Child 3'))
        ],
      ),
    );
  }
}