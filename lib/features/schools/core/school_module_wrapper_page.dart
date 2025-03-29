import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_latest/features/schools/core/schools_injection_module.dart';

import '../../../core/data/base_service.dart';
import '../data/repository/schools_repository_impl.dart';
import '../domain/use_cases/delete_school_usecase.dart';
import '../domain/use_cases/school_modify_usecase.dart';
import '../domain/use_cases/school_usecase.dart';
import '../presentation/blocs/schools_bloc/schools_bloc.dart';

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

    return FeatureDiscovery.withProvider(
      persistenceProvider: const NoPersistenceProvider(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => SchoolsBloc(
              SchoolsUseCase(SchoolsRepositoryImpl(baseService), injector()),
              SchoolModifyUseCase(
                  SchoolsRepositoryImpl(baseService), injector()),
              DeleteSchoolUseCase(SchoolsRepositoryImpl(baseService)),
            ),
          ),
        ],
        child: widget
            .child, // This ensures child routes have access to these blocs
      ),
    );
  }
}
