import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsolateWithCompute extends StatelessWidget {
   IsolateWithCompute({Key? key}) : super(key: key);

  final stream = StreamController();
   final int iteration = 7000000000;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                direction: Axis.vertical,
                spacing: 20,
                children: [
                  ElevatedButton(onPressed: withoutCompute, child: const Text('Without Isolate')),
                  ElevatedButton(onPressed: withCompute, child: const Text('With Isolate')),
                  ElevatedButton(onPressed: runHeavyTaskWithIsolated, child: const Text('With Spawan')),
                  ElevatedButton(onPressed: refresh, child: const Text('Refresh')),
                ],
              ),
            ),
            Expanded(
                child: Center(
              child: StreamBuilder(
                  stream: stream.stream,
                  builder: (context, snapShotData) {
                    if (snapShotData.hasData) {
                      return Text(snapShotData.data.toString(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold));
                    }
                    return const CircularProgressIndicator();
                  }),
            ))
          ],
        ),
      ),
    );
  }

  void refresh() => stream.add(null);

  void withoutCompute() async {
      var count = complexOperation(iteration);
      stream.add(count);
  }

   void withCompute() async {
    var count = await compute(complexOperation, iteration);
    stream.add(count);
  }

  void runHeavyTaskWithIsolated() async {
    final receivePort = ReceivePort();
    try{
      await Isolate.spawn(spawnComplexOperation, [receivePort.sendPort, iteration]);
      // receivePort.listen((message) {
      //
      // });
      var filteredCount = receivePort.first;
      stream.add(filteredCount);
    }catch(e,s){
      receivePort.close();
      debugPrint('Isolate spwan error');
    }
  }

  void spawnComplexOperation(List<dynamic> args) async {
    SendPort resultPort = args[0];
    var filteredCount = complexOperation(args[0]);
    resultPort.send(filteredCount);
  }

  static int complexOperation(int count) {
    var value = 0;
    for(int i = 0; i < count; i++){
      value += i;
    }
    return value;
  }


}


