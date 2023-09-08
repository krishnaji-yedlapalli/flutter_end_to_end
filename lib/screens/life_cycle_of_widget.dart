import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:workmanager/workmanager.dart';

class LifeCycleWidget1 extends StatefulWidget {
  const LifeCycleWidget1({Key? key}) : super(key: key);

  @override
  State<LifeCycleWidget1> createState() => _LifeCycleWidget1State();
}

class _LifeCycleWidget1State extends State<LifeCycleWidget1> {

  String randomName = 'Krishna';
  @override
  void initState() {

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant LifeCycleWidget1 oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: updateRandomName, child: Text('pass random button')),
          ElevatedButton(onPressed: isolate, child: Text('isolates')),
          ElevatedButton(onPressed: workManger, child: Text('work manger')),
           LifeCycleChildWidget(randomName)
        ],
      ),
    );
  }

  void isolate() async {
    var res = await compute(runTimer, 60);
    print(res);
  }

  void workManger() {
    var si = 'be.tramckrijte.workmanagerExample.simpleTask';
    Workmanager().registerOneOffTask(
        si,
        si,
        initialDelay: Duration(seconds: 10),
        inputData: <String, dynamic>{
          'int': 1 }
    );
  }

  static Future<int>  runTimer(int a) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    int i = 0;
    while(i < a) {
      await Future.delayed(Duration(seconds: 1));
      // prefs.setInt('getTime', i);
      i++;
    }
    return i;
  }

  void updateRandomName() {
    setState(() {
     var r = Random();
     randomName = String.fromCharCodes(List.generate(10, (index) => r.nextInt(33) + 89));
    });
  }
}

class LifeCycleChildWidget extends StatefulWidget {
  final String randomName;
  const LifeCycleChildWidget(this.randomName, {Key? key}) : super(key: key);

  @override
  State<LifeCycleChildWidget> createState() => _LifeCycleChildWidgetState();
}

class _LifeCycleChildWidgetState extends State<LifeCycleChildWidget> with SingleTickerProviderStateMixin {

  late AnimationController ctrl;
  @override
  void initState() {
    print('idle phase 1 : ${SchedulerBinding.instance.schedulerPhase}'); /// SchedulerPhase.idle

    ctrl = AnimationController(vsync: this, duration: Duration(seconds: 1))..addListener(() {
      print('Animation started phase : ${SchedulerBinding.instance.schedulerPhase}'); /// transient callbacks
    })..forward();
    /// this will be executed one frame is constructed only.
    Future.delayed(Duration(seconds: 2), () {
      print('shceduler phase 2 : ${SchedulerBinding.instance.schedulerPhase}');
      someAsyncronusTask();
    },); ///
    super.initState();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant LifeCycleChildWidget oldWidget) {
    var a = List.generate(1000000, (index) => 1000000/2).toList();  /// this line of code creates junk
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(performSomeArthmaticOperations()),
    );
  }


  String performSomeArthmaticOperations() {
    return widget.randomName;
  }

  Future<void> someAsyncronusTask() async {
    print('asyncronus method : ${SchedulerBinding.instance.schedulerPhase}');
    await Future.delayed(const Duration(seconds: 1));
  }
}

