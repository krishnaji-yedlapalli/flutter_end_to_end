import 'package:app_core/core/mixins/feature_discovery_mixin.dart';
import 'package:app_core/core/utils/enums_type_def.dart';
import 'package:app_core/shared/exception/exception.dart';
import 'package:app_core/shared/mixins/mixins.dart';
import 'package:app_core/shared/widgets/non_responsive_widgets/custom_app_bar.dart';
import 'package:feature_discovery_module/school_feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:schools/presentation/pages/schools/schools_view.dart';
import 'package:schools/presentation/ui_models/schools_ui_model.dart';
import 'package:schools/shared/models/school_view_model.dart';

import '../../cubit/schools_cubit/schools_cubit.dart';
import 'widgets/create_update_school.dart';

class SchoolsPage extends StatefulWidget {
  const SchoolsPage({super.key});

  @override
  State<SchoolsPage> createState() => _SchoolsPageState();
}

class _SchoolsPageState extends State<SchoolsPage>
    with Loaders, CustomDialogs, HelperWidget, FeatureDiscovery {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<SchoolsCubit>(context).loadSchools();
      SchoolScreenFeatureDiscovery().startFeatureDiscovery(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SchoolsCubit, SchoolsState>(
        listener: (context, state) {
          switch (state) {
            case SchoolsInfoInitial():
              buildAlertDialog(context,
                  title: '!!! Welcome to School Module !!!',
                  content:
                      'Whole Module is developed with Flutter BLoc pattern and Integrated with Firebase realtime data base Rest apis');
            case SchoolsInfoOverlayLoading():
              handleOverlayLoader(context, state.isLoading);
            case _:

            /// Do nothing
          }
        },
        listenWhen: (prev, curr) =>
            curr is SchoolsInfoInitial || curr is SchoolsInfoOverlayLoading,
        buildWhen: (prev, curr) => curr is SchoolsInfoInitial,
        builder: (context, state) {
          if (state is SchoolsInfoLoading) {
            return circularLoader();
          } else if (state is SchoolsInfoInitial) {
            return _buildPage(state.schoolsUiModel);
          } else if (state is SchoolDataError) {
            return ExceptionView(state.errorStateType);
          } else {
            return Container();
          }
        });
  }

  Widget _buildPage(SchoolsUiModel uiModel) {
    return Scaffold(
        appBar: CustomAppBar(
          title: const Text('Schools'),
          actions: [
            featureDiscovery(() => SchoolScreenFeatureDiscovery()
                .startFeatureDiscovery(context, forceTour: true))
          ],
          appBar: AppBar(),
        ),
        floatingActionButton: SchoolScreenFeatureDiscovery()
            .aboutSchoolDiscovery(
                type: SchoolDiscoverFeatureType.create,
                child: FloatingActionButton.extended(
                    onPressed: onTapOfCreateSchool,
                    label: const Text('Create School'),
                    icon: const Icon(Icons.add))),
        body: _buildSchoolConsumer());
  }

  Widget _buildSchoolConsumer() {
    return BlocBuilder<SchoolsCubit, SchoolsState>(
        buildWhen: (previous, current) => current is! SchoolsInfoOverlayLoading,
        builder: (context, state) {
          if (state is SchoolsInfoInitial || state is SchoolsInfoLoading) {
            return circularLoader();
          } else if (state is SchoolsInfoLoaded) {
            return SchoolsView(
              schools: state.schoolsUiModel.schools,
              onTap: onSchoolTapAction,
            );
          } else if (state is SchoolDataError) {
            return ExceptionView(state.errorStateType);
          } else {
            return Container();
          }
        });
  }

  void onSchoolTapAction(SchoolViewModel school, SchoolActionType type) {
    switch (type) {
      case SchoolActionType.edit:
        onTapOfEditSchool(school);
      case SchoolActionType.delete:
        onTapOfSchoolDelete(school);
      case SchoolActionType.select:
        onTapOfSchool(school);
    }
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

  onTapOfSchoolDelete(SchoolViewModel school) {
    BlocProvider.of<SchoolsCubit>(context).deleteSchool(school.id);
  }

  void handleOverlayLoader(BuildContext context, bool isLoading) {
    isLoading ? context.loaderOverlay.show() : context.loaderOverlay.hide();
  }
}
