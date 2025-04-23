import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class DailyTrackerEventList extends StatefulWidget {
  const DailyTrackerEventList({super.key});

  @override
  State<DailyTrackerEventList> createState() => _DailyTrackerEventListState();
}

class _DailyTrackerEventListState extends State<DailyTrackerEventList> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('events');

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      query: _databaseReference,
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation<double> animation, int index) {
        Map data = snapshot.value as Map;
        String dataString =
            data['events'].toString(); // Modify as per your data structure
        return ListTile(
          title: Text(dataString),
        );
      },
    );
  }
}
