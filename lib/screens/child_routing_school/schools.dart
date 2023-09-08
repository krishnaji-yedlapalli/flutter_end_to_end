
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Schools extends StatefulWidget {
  const Schools({Key? key}) : super(key: key);

  @override
  State<Schools> createState() => _SchoolsState();
}

class _SchoolsState extends State<Schools> {

  List<(String, String, int)> schools = [('Oxford', 'Narendrapuram', 234234)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      children: List.generate(schools.length, (index) => InkWell(
        onTap: () => onTapOfSchool(schools.elementAt(index)),
        child: Card(child:
          Text(schools.elementAt(index).$1)),
      )),
      ),
    );
  }

  onTapOfSchool((String, String, int) school) {
   context.go(Uri(
    path: '/schools/schoolDetails',
    queryParameters: {
      'name' : school.$1,
      'address' : school.$2,
      'pincode' : school.$3.toString(),
    }
   ).toString());
  }
}
