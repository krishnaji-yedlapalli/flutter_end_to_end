
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SchoolDetails extends StatefulWidget {
  final (String, String, int) schoolDetails;
  const SchoolDetails(this.schoolDetails, {Key? key}) : super(key: key);

  @override
  State<SchoolDetails> createState() => _SchoolDetailsState();
}

class _SchoolDetailsState extends State<SchoolDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const Text('School Details'),
        Text(widget.schoolDetails.$1),
        Text(widget.schoolDetails.$2),
        Text(widget.schoolDetails.$3.toString()),
        ElevatedButton(onPressed: onTapOfViewStudents, child: Text('View students'))
      ],),
    );
  }

  onTapOfViewStudents() {
    context.go('/schools/schoolDetails/students');
  }
}
