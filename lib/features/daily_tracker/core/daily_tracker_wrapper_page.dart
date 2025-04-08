import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_latest/features/daily_tracker/core/daily_tracker_injection_module.dart';
import 'package:sample_latest/features/schools/core/schools_injection_module.dart';

import '../../../core/data/base_service.dart';
import '../data/repository/daily_tracker_repository.dart';
import '../presentation/bloc/daily_status_tracker_bloc.dart';


class DailyTrackerWrapperPage extends StatefulWidget {
  const DailyTrackerWrapperPage({super.key, required this.child});

  final Widget child;

  @override
  State<DailyTrackerWrapperPage> createState() =>
      _DailyTrackerWrapperPageState();
}

class _DailyTrackerWrapperPageState extends State<DailyTrackerWrapperPage> {
  @override
  void initState() {
    /// Singleton class
    DailyTrackerInjectionModule().registerDependencies();
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
          BlocProvider(create: (BuildContext context) => DailyTrackerStatusBloc(DailyTrackerRepository()),)
        ],
        child: widget.child, // This ensures child routes have access to these blocs
      ),
    );
  }
}
