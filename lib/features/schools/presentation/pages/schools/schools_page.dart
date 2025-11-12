import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/core/mixins/feature_discovery_mixin.dart';
import 'package:sample_latest/core/utils/enums_type_def.dart';
import 'package:sample_latest/features/feature_discovery/school_feature_discovery.dart';
import 'package:sample_latest/features/schools/presentation/pages/schools/schools_view.dart';
import 'package:sample_latest/features/schools/shared/models/school_view_model.dart';
import 'package:sample_latest/shared/exception/exception.dart';
import 'package:sample_latest/shared/extensions/extensions.dart';
import 'package:sample_latest/shared/widgets/non_responsive_widgets/custom_app_bar.dart';

import '../../../../../shared/mixins/mixins.dart';
import '../../cubit/schools_cubit/schools_cubit.dart';
import 'widgets/create_update_school.dart';
import 'widgets/schools_offline_actions.dart';

class SchoolsPage extends StatefulWidget {
  const SchoolsPage({super.key});

  @override
  State<SchoolsPage> createState() => _SchoolsPageState();
}

class _SchoolsPageState extends State<SchoolsPage>
    with Loaders, CustomDialogs, HelperWidget, FeatureDiscovery {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Schools'),
        actions: [
          featureDiscovery(() => SchoolScreenFeatureDiscovery()
              .startFeatureDiscovery(context, forceTour: true))
        ],
        appBar: AppBar(),
      ),
      floatingActionButton: SchoolScreenFeatureDiscovery().aboutSchoolDiscovery(
          type: SchoolDiscoverFeatureType.create,
          child: FloatingActionButton.extended(
              onPressed: onTapOfCreateSchool,
              label: const Text('Create School'),
              icon: const Icon(Icons.add))),
      body: BlocListener<SchoolsCubit, SchoolsState>(
        listener: (context, state) {
          buildAlertDialog(context,
              title: '!!! Welcome to School Module !!!',
              content:
                  'Whole Module is developed with Flutter BLoc pattern and Integrated with Firebase realtime data base Rest apis');
          BlocProvider.of<SchoolsCubit>(context)
              .updateWelcomeMessageStatus(true);
        },
        listenWhen: (oldState, state) {
          return !state.isWelcomeMessageShown;
        },
        child: _buildSchoolConsumer(),
      ),
    );
  }

  Widget _buildSchoolConsumer() {
    return BlocBuilder<SchoolsCubit, SchoolsState>(builder: (context, state) {
      if (state is SchoolsInfoInitial || state is SchoolsInfoLoading) {
        return circularLoader();
      } else if (state is SchoolsInfoLoaded) {
        return SchoolsView(
          schools: state.schoolsUiModel.schools,
          onTap: (school, type) {},
        );
      } else if (state is SchoolDataError) {
        return ExceptionView(state.errorStateType);
      } else {
        return Container();
      }
    });
  }

  onTapOfSchool(SchoolViewModel school) {
    var query = {"schoolId": school.id};

    context.go(
        Uri(path: '/home/schools/school-details', queryParameters: query)
            .toString(),
        extra: school);
  }

  onTapOfCreateSchool() {
    adaptiveDialog(context, CreateSchool(parentContext: context));
  }

  onTapOfEditSchool(SchoolViewModel school) {
    adaptiveDialog(
        context, CreateSchool(parentContext: context, school: school));
  }

  onTapOfSchoolDelete(String schoolId) {
    BlocProvider.of<SchoolsCubit>(context).deleteSchool(schoolId);
  }
}
