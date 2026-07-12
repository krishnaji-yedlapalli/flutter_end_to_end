import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:schools/core/schools_injection_module.dart';
import 'package:schools/presentation/cubit/school_details_bloc/school_details_bloc.dart';
import 'package:schools/presentation/cubit/students_bloc/students_bloc.dart';

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
    SchoolsInjectionModule().registerDependencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var injector = GetIt.instance;

    return FeatureDiscovery.withProvider(
      persistenceProvider: const NoPersistenceProvider(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => injector<SchoolsCubit>()),
          BlocProvider(create: (_) => injector<SchoolDetailsBloc>()),
          BlocProvider(create: (_) => injector<StudentsBloc>()),
        ],
        child: widget.child,
      ),
    );
  }
}
