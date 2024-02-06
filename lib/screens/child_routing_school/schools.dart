import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/data/models/school/school_model.dart';
import 'package:sample_latest/extensions/widget_extension.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

class Schools extends StatefulWidget {
  const Schools({Key? key}) : super(key: key);

  @override
  State<Schools> createState() => _SchoolsState();
}

class _SchoolsState extends State<Schools> {
  @override
  void initState() {
      BlocProvider.of<SchoolBloc>(context).add(SchoolsDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Schools'),
        appBar: AppBar(),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){}, label: Text('Create School'), icon: Icon(Icons.add)),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Registered Schools:', style: Theme.of(context).textTheme.titleMedium)],
          ),
          Expanded(child: _buildSchoolBlocConsumer()),
        ],
      ).screenPadding(),
    );
  }

  Widget _buildSchoolBlocConsumer() {
    return BlocConsumer<SchoolBloc, SchoolState>(
        listener: (context, state) {
        },
        // listenWhen: (context, state) {
        //   return state is DataLoaded && state is List<SchoolModel>;
        // },
        buildWhen: (context, state) {
          return state.schoolStateType == SchoolDataLoadedType.schools;
        },
        builder: (context, state) {
          if (state is SchoolInfoInitial || state is SchoolInfoLoading) {
            return const CircularProgressIndicator();
          } else if (state is SchoolsInfoLoaded) {
            return _buildRegisteredSchools(state.schools);
          } else {
            return Container();
          }
        });
  }

  Widget _buildRegisteredSchools(List<SchoolModel> schools) {
    return DeviceConfiguration.isMobileResolution ? ListView.builder(
        itemCount: schools.length,
        itemBuilder: (context, index) {
          var school = schools.elementAt(index);
          return ListTile(
            leading: const Icon(Icons.school),
            title: Text(school.schoolName),
            subtitle: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children:[
                    const TextSpan(text: 'Country :', style: TextStyle(color: Colors.orange)),
                    TextSpan(text:  school.country),
                  ]
                )),
            onTap: () => onTapOfSchool(school),
          );
        }) :
      GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      shrinkWrap: true,
      children: List.generate(
          schools.length,
          (index) => InkWell(
                onTap: () => onTapOfSchool(schools.elementAt(index)),
                child: Card(
                  child: Text(schools.elementAt(index).schoolName),
                ),
              )),
    );
  }

  onTapOfSchool(SchoolModel school) {
    context.go(Uri(path: '/home/schools/schoolDetails', queryParameters: {"schoolId" : school.id.toString()}).toString(), extra: (school, null));
  }
}
