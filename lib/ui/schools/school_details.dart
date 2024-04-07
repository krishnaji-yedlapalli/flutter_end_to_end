import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/models/school/school_details_model.dart';
import 'package:sample_latest/models/school/school_model.dart';
import 'package:sample_latest/models/school/student_model.dart';
import 'package:sample_latest/services/utils/service_enums_typedef.dart';
import 'package:sample_latest/extensions/widget_extension.dart';
import 'package:sample_latest/mixins/dialogs.dart';
import 'package:sample_latest/mixins/helper_widgets_mixin.dart';
import 'package:sample_latest/mixins/loaders.dart';
import 'package:sample_latest/ui/schools/add_update_school_details.dart';
import 'package:sample_latest/ui/schools/create_update_student.dart';
import 'package:sample_latest/ui/exception/exception.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/utils/enums_type_def.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

import '../../bloc/school/school_bloc.dart';

class SchoolDetails extends StatefulWidget {

  final SchoolModel? school;

  final String schoolId;

  const SchoolDetails(this.schoolId, this.school, {Key? key}) : super(key: key);

  @override
  State<SchoolDetails> createState() => _SchoolDetailsState();
}

class _SchoolDetailsState extends State<SchoolDetails>
    with HelperWidget, Loaders, CustomDialogs {
  @override
  void initState() {
    BlocProvider.of<SchoolBloc>(context)
      ..add(SchoolDataEvent(widget.schoolId))
      ..viewAllStudents = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: CustomAppBar(appBar: AppBar()),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: onTapOfCreateStudent, label: const Text('Create Student')),
        body: _buildSchoolBloc());
  }

  Widget _buildSchoolBloc() {
    return BlocConsumer<SchoolBloc, SchoolState>(
      buildWhen: (context, state) {
        return state.schoolStateType == SchoolDataLoadedType.school;
      },
      builder: (context, state) {
        if (state is SchoolInfoInitial || state is SchoolInfoLoading) {
          return circularLoader();
        } else if (state is SchoolInfoLoaded) {
          return _buildSchoolDetails(state.school);
        }else if(state is SchoolDataNotFound){
          return _buildEmptySchoolView();
        } else if(state is SchoolDataError) {
          return ExceptionView(state.errorStateType);
        }else {
          return const ExceptionView((DataErrorStateType.none, message: null));
        }
      },
      listener: (BuildContext context, SchoolState state) {},
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
            background: CachedNetworkImage(imageUrl: 'https://www.shutterstock.com/image-photo/student-creative-desk-mock-colorful-260nw-2128291856.jpg', fit: BoxFit.fill, placeholder: (context, error) {return Icon(Icons.image);}, errorWidget: (context, error, o)=> const Icon(Icons.image), ),
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
            if(context.watch<SchoolBloc>().viewAllStudents) _buildViewStudentsBtn(widget.schoolId),
          ],
        )
        ),
        SliverToBoxAdapter(
          child: _buildStudentsBloc(),
        )
      ],
    );
  }

  Widget _buildSchoolDetails(SchoolDetailsModel schoolDetails) {
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
           if(context.watch<SchoolBloc>().viewAllStudents) _buildViewStudentsBtn(schoolDetails.id),
           if(!context.watch<SchoolBloc>().viewAllStudents) Text('Students :', style: Theme.of(context).textTheme.headlineMedium?.apply(color: Colors.orange))
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
            .read<SchoolBloc>()
            .add(StudentsDataEvent(id)),
        child: const Text('View Students'));
  }

  Widget _buildValue(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStudentsBloc() {
    return BlocConsumer<SchoolBloc, SchoolState>(
      buildWhen: (context, state) {
        return state.schoolStateType == SchoolDataLoadedType.students;
      },
      builder: (context, state) {
        if (state is SchoolInfoInitial || state is SchoolInfoLoading) {
          return circularLoader();
        } else if (state is StudentsInfoLoaded) {
          return _buildStudents(state.students);
        } else if(state is SchoolDataError) {
          return ExceptionView(state.errorStateType);
        } else {
          return Container();
        }
      },
      listener: (BuildContext context, SchoolState state) {},
    );
  }


  Widget _buildStudents(
      List<StudentModel> students) {

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
    adaptiveDialog(context, AddSchoolDetails(school: widget.school!));
  }

  onTapOfCreateStudent() {
    adaptiveDialog(context, CreateStudent(widget.schoolId));
  }

  onTapOfCreateUpdate(StudentModel student) {
    adaptiveDialog(context, CreateStudent(widget.schoolId, student: student));
  }

  onTapOfViewStudents(String id, String schoolId) {
    Map<String, String> query = <String, String>{};
    query['studentId'] = id;
    query['schoolId'] = widget.schoolId;
    context.go(Uri(
        path: '/home/schools/school-details/student', queryParameters: query).toString());
  }
}
