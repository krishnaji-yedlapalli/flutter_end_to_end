import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/extensions/widget_extension.dart';
import 'package:sample_latest/core/mixins/helper_widgets_mixin.dart';
import 'package:sample_latest/core/mixins/loaders.dart';
import 'package:sample_latest/features/schools/presentation/blocs/students_bloc/students_bloc.dart';
import 'package:sample_latest/features/schools/shared/models/student_view_model.dart';
import 'package:sample_latest/ui/exception/exception.dart';
import 'package:sample_latest/core/widgets/custom_app_bar.dart';

import '../../blocs/students_bloc/students_state.dart';

class Student extends StatefulWidget {
  final String studentId;
  final String schoolId;
  const Student({Key? key, required this.studentId, required this.schoolId})
      : super(key: key);

  @override
  State<Student> createState() => _ChildListState();
}

class _ChildListState extends State<Student> with HelperWidget, Loaders {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((val) {
      BlocProvider.of<StudentsBloc>(context)
          .loadStudent(widget.studentId, widget.schoolId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(appBar: AppBar()), body: _buildSchoolBloc());
  }

  Widget _buildSchoolBloc() {
    return BlocConsumer<StudentsBloc, StudentsState>(
      // listenWhen: (context, state) {
      //   return state is DataLoaded && state.data is StudentModel;
      // },
      // buildWhen: (context, state) {
      //   return state.schoolStateType == SchoolDataLoadedType.student;
      // },
      builder: (context, state) {
        if (state is StudentsInfoInitial || state is StudentsInfoLoading) {
          return circularLoader();
        } else if (state is StudentInfoLoaded) {
          return _buildStudentDetails(state.student);
        } else if (state is SchoolDataError) {
          return ExceptionView(state.errorStateType);
        } else {
          return Container();
        }
      },
      listener: (BuildContext context, StudentsState state) {},
    );
  }

  Widget _buildStudentDetails(StudentViewModel student) {
    return Column(
      children: [
        Text('Student Details :',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.apply(color: Colors.orange)),
        _buildStudent(student),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
              onPressed: deleteStudent,
              icon: const Icon(Icons.delete),
              label: const Text('Delete Student'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
        )
      ],
    ).screenPadding();
  }

  Widget _buildStudent(StudentViewModel student) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 20,
      children: [
        buildLabelWithValue('Student Name', student.studentName),
        buildLabelWithValue('Location ', student.studentLocation),
        buildLabelWithValue('Standard ', student.standard),
      ],
    );
  }

  void deleteStudent() {
    GoRouter.of(context).pop();
    BlocProvider.of<StudentsBloc>(context)
        .deleteStudent(widget.studentId, widget.schoolId);
  }
}
