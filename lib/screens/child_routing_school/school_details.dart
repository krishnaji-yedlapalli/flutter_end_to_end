import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/data/models/school/school_details_model.dart';
import 'package:sample_latest/data/models/school/school_model.dart';
import 'package:sample_latest/data/models/school/student_model.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

import '../../bloc/school/school_bloc.dart';

class SchoolDetails extends StatefulWidget {
  final int id;
  const SchoolDetails(this.id, {Key? key}) : super(key: key);

  @override
  State<SchoolDetails> createState() => _SchoolDetailsState();
}

class _SchoolDetailsState extends State<SchoolDetails> {

  @override
  void initState() {
    BlocProvider.of<SchoolBloc>(context)
        .add(SchoolDataEvent(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(appBar: AppBar()), body: _buildSchoolBloc());
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
          return _buildSchoolDetails(state.school);
        } else {
          return Container();
        }
      },
      listener: (BuildContext context, SchoolState state) {},
    );
  }

  Widget _buildSchoolDetails(SchoolDetailsModel schoolDetails) {
    return Column(
      children: [
        const Text('School Details'),
        Text(schoolDetails.schoolName ?? ''),
        // Text(widget.schoolDetails.$2),
        // Text(widget.schoolDetails.$3.toString()),
        _buildStudentsBloc(),
        ElevatedButton(onPressed: ()=> context.read<SchoolBloc>().add(StudentsDataEvent(schoolDetails.id)), child: Text('View All Students'))
      ],
    );
  }
  Widget _buildStudentsBloc() {
    return BlocConsumer<SchoolBloc, SchoolState>(
      // listenWhen: (context, state) {
      //
      // },
      buildWhen: (context, state) {
        return state.schoolStateType == SchoolDataLoadedType.students;
      },
      builder: (context, state) {
        if (state is SchoolInfoInitial || state is SchoolInfoLoading) {
          return const CircularProgressIndicator();
        } else if (state is StudentsInfoLoaded) {
          return _buildStudents(state.students, state.school);
        } else {
          return Container();
        }
      },
      listener: (BuildContext context, SchoolState state) {},
    );
  }

  Widget _buildStudents(List<StudentModel> students, SchoolDetailsModel details) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      shrinkWrap: true,
      children: List.generate(
          students.length,
          (index) => InkWell(
                onTap: () => onTapOfViewStudents(students.elementAt(index).id, details.id),
                child: Card(
                  child: Text(students.elementAt(index).studentName),
                ),
              )),
    );
  }

  onTapOfViewStudents(int id, int schoolId) {
    context.go(Uri(path: '/home/schools/schoolDetails/student', queryParameters: {'studentId' : id.toString(), 'schoolId' : schoolId.toString()}).toString());
  }
}
