import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/models/school/student_model.dart';
import 'package:sample_latest/extensions/widget_extension.dart';
import 'package:sample_latest/mixins/helper_widgets_mixin.dart';
import 'package:sample_latest/mixins/loaders.dart';
import 'package:sample_latest/ui/exception/exception.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

class Student extends StatefulWidget {
  final String studentId;
  final String schoolId;
  const Student({Key? key, required this.studentId, required this.schoolId})
      : super(key: key);

  @override
  State<Student> createState() => _ChildListState();
}

class _ChildListState extends State<Student> with HelperWidget, Loaders{
  @override
  void initState() {
    BlocProvider.of<SchoolBloc>(context)
        .add(StudentDataEvent(widget.studentId, widget.schoolId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(appBar: AppBar()), body: _buildSchoolBloc());
  }

  Widget _buildSchoolBloc() {
    return BlocConsumer<SchoolBloc, SchoolState>(
      // listenWhen: (context, state) {
      //   return state is DataLoaded && state.data is StudentModel;
      // },
      buildWhen: (context, state) {
        return state.schoolStateType == SchoolDataLoadedType.student;
      },
      builder: (context, state) {
        if (state is SchoolInfoInitial || state is SchoolInfoLoading) {
          return circularLoader();
        } else if (state is StudentInfoLoaded) {
          return _buildStudentDetails(state.student);
        }  else if(state is SchoolDataError) {
          return ExceptionView(state.errorStateType);
        }else {
          return Container();
        }
      },
      listener: (BuildContext context, SchoolState state) {},
    );
  }

  Widget _buildStudentDetails(StudentModel student) {
    return Column(
      children: [
      Text('Student Details :', style: Theme.of(context).textTheme.headlineSmall?.apply(color: Colors.orange)),
        _buildStudent(student),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(onPressed: deleteStudent, icon: Icon(Icons.delete), label : Text('Delete Student'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
        )
      ],
    ).screenPadding();
  }

  Widget _buildStudent(StudentModel student) {
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
    BlocProvider.of<SchoolBloc>(context).add(DeleteStudentEvent(widget.studentId, widget.schoolId));
  }
}
