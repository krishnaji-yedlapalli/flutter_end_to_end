import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/data/models/school/school_model.dart';
import 'package:sample_latest/data/models/school/student_model.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

import '../../bloc/school/school_bloc.dart';

class SchoolDetails extends StatefulWidget {
  final SchoolModel schoolDetails;
  const SchoolDetails(this.schoolDetails, {Key? key}) : super(key: key);

  @override
  State<SchoolDetails> createState() => _SchoolDetailsState();
}

class _SchoolDetailsState extends State<SchoolDetails> {
  @override
  void initState() {
    BlocProvider.of<SchoolBloc>(context).add(SchoolDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(appBar: AppBar()), body: _buildSchoolDetails());
  }

  Widget _buildSchoolDetails() {
    return Column(
      children: [
        const Text('School Details'),
        Text(widget.schoolDetails.schoolName),
        // Text(widget.schoolDetails.$2),
        // Text(widget.schoolDetails.$3.toString()),
        _buildSchoolBloc(),
        ElevatedButton(onPressed: onTapOfViewStudents, child: Text('View students'))
      ],
    );
  }

  Widget _buildSchoolBloc() {
    return BlocConsumer<SchoolBloc, SchoolState>(
      // listenWhen: (context, state) {
      //
      // },
      buildWhen: (context, state) {
        return state.schoolStateType == SchoolDataLoadedType.school;
      },
      builder: (context, state) {
        if (state is SchoolInfoInitial || state is SchoolInfoLoading) {
          return const CircularProgressIndicator();
        } else if (state is SchoolInfoLoaded) {
          return _buildDetails(state.school);
        } else {
          return Container();
        }
      },
      listener: (BuildContext context, SchoolState state) {},
    );
  }

  Widget _buildDetails(SchoolModel school) {
    return Text('sd');
  }

  Widget _buildStudents(List<StudentModel> students) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      shrinkWrap: true,
      children: List.generate(
          students.length,
          (index) => InkWell(
                onTap: () => {},
                child: Card(
                  child: Text(students.elementAt(index).studentName),
                ),
              )),
    );
  }

  onTapOfViewStudents() {
    context.go(Uri(path: '/home/schools/schoolDetails/students', queryParameters: widget.schoolDetails.toJson(),).toString() );
  }
}
