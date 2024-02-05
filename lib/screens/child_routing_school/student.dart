

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/data/models/school/student_model.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _ChildListState();
}

class _ChildListState extends State<Student> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<SchoolBloc>(context).add(StudentDataEvent());
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(appBar: AppBar()),
        body: _buildSchoolBloc()
    );
  }


  Widget _buildSchoolBloc() {
    return BlocConsumer<SchoolBloc, SchoolState>(
      // listenWhen: (context, state) {
      //   return state is DataLoaded && state.data is StudentModel;
      // },
      // buildWhen: (DataState pageState, state) {
      //   return state is DataLoaded && state.data is List<StudentModel>;
      // },
      buildWhen: (context, state) => state.schoolStateType == SchoolDataLoadedType.students,
      builder: (context, state) {
        if (state is SchoolInfoInitial || state is SchoolInfoLoading) {
          return const CircularProgressIndicator();
        } else if (state is StudentInfoLoaded) {
          return _buildStudents(state.student);
        } else {
          return Container();
        }
      }, listener: (BuildContext context, SchoolState state) {},
    );
  }


  Widget _buildStudents(StudentModel student) {
    return Container(child: Text('studnet'));
  }
}