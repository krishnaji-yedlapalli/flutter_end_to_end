import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:sample_latest/core/extensions/widget_extension.dart';
import 'package:sample_latest/core/mixins/dialogs.dart';
import 'package:sample_latest/core/mixins/helper_widgets_mixin.dart';
import 'package:sample_latest/core/mixins/loaders.dart';
import 'package:sample_latest/features/schools/presentation/blocs/school_details_bloc/school_details_bloc.dart';
import 'package:sample_latest/features/schools/presentation/blocs/students_bloc/students_bloc.dart';
import 'package:sample_latest/features/schools/presentation/screens/school_details/add_update_school_details.dart';
import 'package:sample_latest/features/schools/presentation/screens/student/create_update_student.dart';
import 'package:sample_latest/features/schools/shared/models/student_view_model.dart';
import 'package:sample_latest/ui/exception/exception.dart';
import 'package:sample_latest/utils/device_configurations.dart';

import '../../../shared/models/school_details_view_model.dart';
import '../../../shared/models/school_view_model.dart';
import '../../blocs/school_details_bloc/schools_details_state.dart';
import '../../blocs/students_bloc/students_state.dart';

class SchoolDetails extends StatefulWidget {

  final SchoolViewModel? school;

  final String schoolId;

  const SchoolDetails(this.schoolId, this.school, {Key? key}) : super(key: key);

  @override
  State<SchoolDetails> createState() => _SchoolDetailsState();
}

class _SchoolDetailsState extends State<SchoolDetails>
    with HelperWidget, Loaders, CustomDialogs {
  @override
  void initState() {
    BlocProvider.of<SchoolDetailsBLoc>(context)
      .loadSchoolDetails(widget.schoolId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: onTapOfCreateStudent, label: const Text('Create Student')),
        body: _buildSchoolBloc());
  }

  Widget _buildSchoolBloc() {
    return BlocConsumer<SchoolDetailsBLoc, SchoolDetailsState>(
      builder: (context, state) {
        if (state is SchoolDetailsInitial || state is SchoolDetailsInitialLoading) {
          return circularLoader();
        } else if (state is SchoolDetailsInfoLoaded) {
          return _buildSchoolDetails(state.schoolDetails);
        }else if(state is SchoolDetailsDataNotFound){
          return _buildEmptySchoolView();
        } else if(state is SchoolDetailsDataError) {
          return ExceptionView(state.errorStateType);
        }else {
          return const ExceptionView((DataErrorStateType.none, message: null));
        }
      }, listener: (BuildContext context, SchoolDetailsState state) {
        if(state is SchoolDetailsInfoLoaded){
          context.read<StudentsBloc>().loadStudents(widget.schoolId);
        }
    },
    );
  }

  Widget _buildEmptySchoolView() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: DeviceConfiguration.isMobileResolution ? 160 : 400,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
                widget.school?.schoolName ?? '',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            background: CachedNetworkImage(imageUrl: 'https://www.shutterstock.com/image-photo/student-creative-desk-mock-colorful-260nw-2128291856.jpg', fit: BoxFit.fill, placeholder: (context, error) {return const Icon(Icons.image);}, errorWidget: (context, error, o)=> const Icon(Icons.image), ),
          ),
        ),
    SliverToBoxAdapter(
        child: Column(
          children: [
            if(widget.school != null) Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                  width: 200,
                  child: ElevatedButton(onPressed: onTapOfAddMoreDetails, child: const Text('Add More details'))),
            ),
            if(context.watch<StudentsBloc>().viewAllStudents) _buildViewStudentsBtn(widget.schoolId),
          ],
        )
        ),
        SliverToBoxAdapter(
          child: _buildStudentsBloc(),
        )
      ],
    );
  }

  Widget _buildSchoolDetails(SchoolDetailsViewModel schoolDetails) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          expandedHeight: DeviceConfiguration.isMobileResolution ? 160 : 400,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              schoolDetails.schoolName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            background: CachedNetworkImage(imageUrl: schoolDetails.image, fit: BoxFit.fill, placeholder: (context, error) {return const Icon(Icons.image);}, errorWidget: (context, error, o)=> const Icon(Icons.image), ),
          ),
        ),
        SliverToBoxAdapter(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                width: DeviceConfiguration.isMobileResolution
                    ? null
                    : MediaQuery.of(context).size.width / 2,
                child: Table(
                  children: [
                    TableRow(children: [
                      const Text('Country :'),
                      _buildValue(schoolDetails.country)
                    ]),
                    TableRow(children: [
                      const Text('Student strength :'),
                      _buildValue(schoolDetails.studentCount.toString())
                    ]),
                    TableRow(children: [
                      const Text('Staff strength :'),
                      _buildValue(schoolDetails.employeeCount.toString())
                    ]),
                    TableRow(children: [
                      const Text('Hostel Availability :'),
                      _buildValue(schoolDetails.hostelAvailability.toString())
                    ])
                  ],
                ),
              ),
            ),
            // Wrap(
            //   children: [
            //     buildLabelWithValue('Country:' , schoolDetails.country)
            //   ],
            // ),
           if(context.watch<StudentsBloc>().viewAllStudents) _buildViewStudentsBtn(schoolDetails.id),
           if(!context.watch<StudentsBloc>().viewAllStudents) Text('Students :', style: Theme.of(context).textTheme.headlineMedium?.apply(color: Colors.orange))
          ],
        ).screenPadding()
        ),
        SliverToBoxAdapter(
          child: _buildStudentsBloc(),
        ),
      ],
    );
  }

  Widget _buildViewStudentsBtn(String id){
    return  ElevatedButton(
        onPressed: () => context
            .read<StudentsBloc>()
            .loadStudents(id),
        child: const Text('View Students'));
  }

  Widget _buildValue(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStudentsBloc() {
    return BlocConsumer<StudentsBloc, StudentsState>(
      buildWhen: (context, state) {
        return state.stateType == StudentStateType.students;
      },
      builder: (context, state) {
        if (state is StudentsInfoInitial || state is StudentsInfoLoading) {
          return circularLoader();
        } else if (state is StudentsInfoLoaded) {
          return _buildStudents(state.students);
        } else if(state is SchoolDataError) {
          return ExceptionView(state.errorStateType);
        } else {
          return Container();
        }
      },
      listener: (BuildContext context, StudentsState state) {},
    );
  }


  Widget _buildStudents(
      List<StudentViewModel> students) {

    if(students.isEmpty) return emptyMessage('No Students to display, Create a New student');

    return SizedBox(
      width: DeviceConfiguration.isMobileResolution ? null : MediaQuery.of(context).size.width/2,
      child: ListView.separated(
          itemCount: students.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var student = students.elementAt(index);
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(student.studentName),
            subtitle: Text(student.standard),
            trailing: IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => onTapOfCreateUpdate(student)),
            onTap:  () => onTapOfViewStudents(
                student.id, widget.schoolId),
          );
      },
      separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  onTapOfAddMoreDetails() {
    adaptiveDialog(context, AddSchoolDetails(school: widget.school!, parentContext: context));
  }

  onTapOfCreateStudent() {
    adaptiveDialog(context, CreateStudent(context, widget.schoolId));
  }

  onTapOfCreateUpdate(StudentViewModel student) {
    adaptiveDialog(context, CreateStudent(context, widget.schoolId, student: student));
  }

  onTapOfViewStudents(String id, String schoolId) {
    Map<String, String> query = <String, String>{};
    query['studentId'] = id;
    query['schoolId'] = widget.schoolId;
    context.go(Uri(
        path: '/home/schools/school-details/student', queryParameters: query).toString());
  }
}
