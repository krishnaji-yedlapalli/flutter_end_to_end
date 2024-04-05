
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_latest/provider/route_provider.dart';
import 'package:sample_latest/routing.dart';
import 'package:go_router/go_router.dart';

class ShellChildOne extends StatelessWidget {
  const ShellChildOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        runSpacing: 10,
        children: [
          Text('Child one ${context.read<RouteProvider>().value}', style: Theme.of(context).textTheme.displayLarge),
          ElevatedButton(onPressed: () => onTap(context), child: Text('Navigate to Child 2'))
        ],
      ),
    );
  }

  void onTap(BuildContext context) {
    var query = {
      'id' : 123
    };
    context.push('/home/route/child2', );
  }
}
