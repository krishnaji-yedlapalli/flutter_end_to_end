import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/device/enums/device_enums.dart';
import 'package:sample_latest/core/device/utils/screen_break_points.dart';
import 'package:sample_latest/core/device/widgets/adaptive_layout_builder.dart';
import 'package:sample_latest/features/schools_mvc/bloc/school_bloc.dart';
import 'package:sample_latest/core/mixins/feature_discovery_mixin.dart';
import 'package:sample_latest/core/data/db/offline_handler.dart';
import 'package:sample_latest/features/schools/data/model/school_model.dart';
import 'package:sample_latest/core/extensions/widget_extension.dart';
import 'package:sample_latest/core/mixins/dialogs.dart';
import 'package:sample_latest/core/mixins/helper_widgets_mixin.dart';
import 'package:sample_latest/core/mixins/loaders.dart';
import 'package:sample_latest/features/feature_discovery/school_feature_discovery.dart';
import 'package:sample_latest/features/schools_mvc/screens/create_update_school.dart';
import 'package:sample_latest/ui/exception/exception.dart';
import 'package:sample_latest/features/schools/presentation/screens/db_configurations_for_devs.dart';
import 'package:sample_latest/features/schools/presentation/screens/dumping_status.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/core/utils/enums_type_def.dart';
import 'package:sample_latest/core/widgets/custom_app_bar.dart';

class Schools extends StatefulWidget {
  const Schools({Key? key}) : super(key: key);

  @override
  State<Schools> createState() => _SchoolsState();
}

class _SchoolsState extends State<Schools>
    with Loaders, CustomDialogs, HelperWidget, FeatureDiscovery {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<SchoolBloc>(context).loadSchools();
      SchoolScreenFeatureDiscovery().startFeatureDiscovery(context);
    });
    super.initState();
  }

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
      body: BlocListener<SchoolBloc, SchoolState>(
        listener: (context, state) {
          buildAlertDialog(context,
              title: '!!! Welcome to School Module !!!',
              content:
                  'Whole Module is developed with Flutter BLoc pattern and Integrated with Firebase realtime data base Rest apis');
          BlocProvider.of<SchoolBloc>(context).isWelcomeMessageShowed = true;
        },
        listenWhen: (oldState, state) {
          return !state.isWelcomeMessageShowed;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Registered Schools:',
                    style: Theme.of(context).textTheme.titleMedium),
                if (DeviceConfiguration.isOfflineSupportedDevice)
                  Wrap(
                    spacing: 10,
                    children: [
                      SchoolScreenFeatureDiscovery().aboutSchoolDiscovery(
                          type: SchoolDiscoverFeatureType.sync,
                          child: _buildSyncButton()),
                      SchoolScreenFeatureDiscovery().aboutSchoolDiscovery(
                          type: SchoolDiscoverFeatureType.dumpOfflineData,
                          child: _buildDumpOfflineButton()),
                      SchoolScreenFeatureDiscovery().aboutSchoolDiscovery(
                          type: SchoolDiscoverFeatureType.setDdConfig,
                          child: _buildDbConfigurationsButtonForDevelopment()),
                      SchoolScreenFeatureDiscovery().aboutSchoolDiscovery(
                          type: SchoolDiscoverFeatureType.resetDb,
                          child: _buildDbClearButton())
                    ],
                  )
              ],
            ),
            Expanded(child: _buildSchoolBlocConsumer()),
          ],
        ).screenPadding(),
      ),
    );
  }

  Widget _buildSchoolBlocConsumer() {
    return BlocBuilder<SchoolBloc, SchoolState>(buildWhen: (context, state) {
      return state.schoolStateType == SchoolDataLoadedType.schools;
    }, builder: (context, state) {
      if (state is SchoolInfoInitial || state is SchoolInfoLoading) {
        return circularLoader();
      } else if (state is SchoolsInfoLoaded) {
        return _buildRegisteredSchools(state.schools);
      } else if (state is SchoolDataError) {
        return ExceptionView(state.errorStateType);
      } else {
        return Container();
      }
    });
  }

  Widget _buildRegisteredSchools(List<SchoolModel> schools) {
    if (schools.isEmpty)
      return emptyMessage('No Schools Found, Create a new School');

    return SizedBox(
      width: DeviceConfiguration.isMobileResolution
          ? null
          : MediaQuery.of(context).size.width / 3,
      child: ListView.separated(
          itemCount: schools.length,
          itemBuilder: (context, index) {
            var school = schools.elementAt(index);
            return ListTile(
              leading: const Icon(Icons.school),
              title: Text(school.schoolName),
              subtitle: RichText(
                  text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                    const TextSpan(
                        text: 'Country :',
                        style: TextStyle(color: Colors.orange)),
                    TextSpan(text: school.country),
                  ])),
              trailing: Wrap(
                children: [
                  SchoolScreenFeatureDiscovery().aboutSchoolDiscovery(
                      type: SchoolDiscoverFeatureType.edit,
                      child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => onTapOfEditSchool(school))),
                  SchoolScreenFeatureDiscovery().aboutSchoolDiscovery(
                      type: SchoolDiscoverFeatureType.delete,
                      child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => onTapOfSchoolDelete(school.id)))
                ],
              ),
              onTap: () => onTapOfSchool(school),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider()),
    );
  }

  Widget _buildSyncButton() {
    return StreamBuilder<int>(
      stream: OfflineHandler().queueItemsCount.stream,
      initialData: 0,
      builder: (context, snapshot) {
        var count = 0;
        if (snapshot.hasData) {
          count = snapshot.data ?? 0;
        }
        return Badge(
            label: Text('$count'),
            child: ElevatedButton(
                onPressed: OfflineHandler().syncData,
                child: const Text('Sync')));
      },
    );
  }

  Widget _buildDbConfigurationsButtonForDevelopment() {
    return ElevatedButton(
        onPressed: () {
          adaptiveDialog(context, const DbConfigurationDialog());
        },
        child: const Text('Set Db Configurations'));
  }

  Widget _buildDumpOfflineButton() {
    return StreamBuilder<OfflineDumpingStatus>(
      stream: OfflineHandler().dumpingOfflineDataStatus.stream,
      builder: (context, snapshot) {
        Widget child;
        OfflineDumpingStatus status = snapshot.data;
        if (status != null) {
          child = Wrap(
              children: [Text(status.title), Text('${status.percentage}%')]);
        } else {
          child = const Text('Dump Offline Data');
        }
        return ElevatedButton(
            onPressed: status == null
                ? onTapOfDumpStatus
                : () => onTapOfDumpStatus(true),
            child: child);
      },
    );
  }

  Widget _buildDbClearButton() {
    return ElevatedButton.icon(
        onPressed: OfflineHandler().eraseAllDatabaseData,
        icon: const Icon(Icons.refresh),
        label: const Text('Reset Whole Db'));
  }

  onTapOfSchool(SchoolModel school) {
    var query = {"schoolId": school.id};

    context.go(
        Uri(path: '/home/schools/school-details', queryParameters: query)
            .toString(),
        extra: school);
  }

  onTapOfCreateSchool() {
    adaptiveDialog(context, const CreateSchool());
  }

  onTapOfEditSchool(SchoolModel school) {
    adaptiveDialog(context, CreateSchool(school: school));
  }

  onTapOfSchoolDelete(String schoolId) {
    BlocProvider.of<SchoolBloc>(context).deleteSchool(schoolId);
  }

  onTapOfDumpStatus([bool isRunning = false]) {
    if (!isRunning) OfflineHandler().dumpOfflineData();
    adaptiveDialog(context, const DumpingStatusView());
  }
}
