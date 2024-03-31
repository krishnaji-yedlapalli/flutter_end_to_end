import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/extensions/widget_extension.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

class StateFulShellRoutingWithIndexed extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const StateFulShellRoutingWithIndexed({Key? key, required this.navigationShell}) : super(key: key);

  @override
  State<StateFulShellRoutingWithIndexed> createState() => _StateFulShellRoutingWithIndexedState();
}

class _StateFulShellRoutingWithIndexedState extends State<StateFulShellRoutingWithIndexed> {
  static const List<String> items = ['Hi', 'Hello', 'Hola'];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: const Text('Stateful Shell Route With indexedStack'),
      ),
      body: Column(
        children: [
          SegmentedButton<int>(
              segments: List.generate(items.length, (index) => ButtonSegment(value: index, label: Text(items.elementAt(index)))).toList(),
              selected: <int>{selectedIndex},
              onSelectionChanged: (Set<int> newSelection) {
                widget.navigationShell.goBranch(selectedIndex);
                setState(() {
                  selectedIndex = newSelection.first;
                });
              }),
          Expanded(child: Container(
            margin: const EdgeInsets.all(16),
            alignment: Alignment.center,
            color: [Colors.blue, Colors.lightGreen, Colors.lightBlueAccent].elementAt(selectedIndex).withOpacity(0.2),
            child: widget.navigationShell,
          ))
        ],
      ).screenPadding(),
    );
  }
}
