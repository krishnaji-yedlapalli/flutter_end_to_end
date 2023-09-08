

import 'package:flutter/material.dart';

class Students extends StatefulWidget {
  const Students({Key? key}) : super(key: key);

  @override
  State<Students> createState() => _ChildListState();
}

class _ChildListState extends State<Students> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('studentss'),
      ),
    );
  }
}
