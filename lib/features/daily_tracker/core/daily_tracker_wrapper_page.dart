import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_latest/features/daily_tracker/core/daily_tracker_injection_module.dart';
import 'package:sample_latest/features/schools/core/schools_injection_module.dart';

import '../../../core/data/base_service.dart';
import '../data/repository/daily_tracker_repository.dart';
import '../data/repository/profiles_repo_impl.dart';
import '../domain/repository/profiles_repository.dart';
import '../domain/usecases/users_useCase.dart';
import '../features/authentication/presentation/cubit/auth_cubit.dart';
import '../features/events/presentation/cubit/events_cubit.dart';
import '../features/greetings/presentation/cubit/check_in_status_cubit.dart';
import '../features/users/presentation/cubit/profiles_cubit.dart';


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
    var injector = GetIt.instance;

    return PopScope(
      onPopInvokedWithResult: (status, result) {
        if(status){
          DailyTrackerInjectionModule().unRegisterDependencies();
        }
      },
      child: FeatureDiscovery.withProvider(
        persistenceProvider: const NoPersistenceProvider(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (BuildContext context) => injector<ProfilesCubit>()),
            BlocProvider(create: (BuildContext context) =>  injector<CheckInStatusCubit>()),
            BlocProvider(create: (BuildContext context) =>  injector<AuthCubit>()),
            BlocProvider(create: (BuildContext context) =>  injector<EventsCubit>(
              param1: context.read<CheckInStatusCubit>()
            )),
          ],
          child: widget.child, // This ensures child routes have access to these blocs
        ),
      ),
    );
  }
}
