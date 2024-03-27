

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/utils/constants.dart';
import 'package:sample_latest/utils/enums_type_def.dart';

class IsolateHome extends StatelessWidget {
  const IsolateHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var a = [('Isolate With and Without Compute', 'Lag', IsolateType.isolateWithWithOutLag), ('Isolate With Spawn', 'Without Lag', IsolateType.isolateWithSpawn)];
    return Scaffold(
      body: GridView.builder(
          itemCount: a.length,
          itemBuilder: (_, index) => Card(
            child: InkWell(
              onTap: () => onTap(a.elementAt(index).$3, context),
              child: Wrap(
                children: [
                  Text(a.elementAt(index).$1),
                  Text(a.elementAt(index).$2),
                ],
              ),
            ),
          ), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2)),
    );
  }

  void onTap(IsolateType isolateType, BuildContext context) {
    switch(isolateType) {
      case IsolateType.isolateWithWithOutLag:
        context.go('/home/isolates/isolateWithWithOutLag');
      case IsolateType.isolateWithSpawn:
        context.go('/home/isolates/isolateWithSpawn');
    }
  }

}
