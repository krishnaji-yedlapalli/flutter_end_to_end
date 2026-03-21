import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_latest/features/schools/core/schools_injection_module.dart';
import '../data/repository/repository.dart';
import '../domain/use_cases/use_cases.dart';
import 'package:sample_latest/features/schools/presentation/cubit/school_details_bloc/school_details_bloc.dart';
import 'package:sample_latest/features/schools/presentation/cubit/students_bloc/students_bloc.dart';
import 'package:sample_latest/features/schools/presentation/ui_mappers/schools_ui_mapper.dart';

import '../../../core/data/base_service.dart';

import '../presentation/cubit/schools_cubit/schools_cubit.dart';

class SchoolModuleWrapperPage extends StatefulWidget {
  const SchoolModuleWrapperPage({super.key, required this.child});

  final Widget child;

  @override
  State<SchoolModuleWrapperPage> createState() =>
      _SchoolModuleWrapperPageState();
}

class _SchoolModuleWrapperPageState extends State<SchoolModuleWrapperPage> {
  @override
  void initState() {
    /// Singleton class
    SchoolsInjectionModule().registerDependencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var baseService = BaseService.instance;
    var injector = GetIt.instance;
    var studentBloc = StudentsBloc(
        StudentsUseCase(StudentsRepositoryImpl(baseService), injector()),
        StudentModifyUseCase(StudentsRepositoryImpl(baseService), injector()),
        DeleteStudentUseCase(StudentsRepositoryImpl(baseService), injector()),
        StudentUseCase(StudentsRepositoryImpl(baseService), injector()));
    return FeatureDiscovery.withProvider(
      persistenceProvider: const NoPersistenceProvider(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => SchoolsCubit(
                schoolsUseCase: SchoolsUseCase(
                  SchoolsRepositoryImpl(baseService),
                  injector(),
                ),
                schoolModifyUseCase: SchoolModifyUseCase(
                    SchoolsRepositoryImpl(baseService), injector()),
                deleteSchoolUsecase: DeleteSchoolUseCase(
                    SchoolsRepositoryImpl(baseService), injector()),
                uiMapper: injector<SchoolsUiMapper>()),
          ),
          BlocProvider(
            create: (BuildContext context) => SchoolDetailsBLoc(
                SchoolDetailsUseCase(
                    SchoolsDetailsRepositoryImpl(baseService), injector()),
                SchoolDetailsModifyUseCase(
                    SchoolsDetailsRepositoryImpl(baseService), injector()),
                studentBloc),
          ),
          BlocProvider(create: (BuildContext context) => studentBloc)
        ],
        child: widget
            .child, // This ensures child routes have access to these blocs
      ),
    );
  }
}
