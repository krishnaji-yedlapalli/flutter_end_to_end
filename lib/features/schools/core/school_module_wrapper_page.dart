import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_latest/features/schools/core/schools_injection_module.dart';
import 'package:sample_latest/features/schools/data/repository/school_details_repository_impl.dart';
import 'package:sample_latest/features/schools/data/repository/students_repository_impl.dart';
import 'package:sample_latest/features/schools/domain/use_cases/student_usecases/delete_student_usecase.dart';
import 'package:sample_latest/features/schools/domain/use_cases/student_usecases/student_modify_usecase.dart';
import 'package:sample_latest/features/schools/domain/use_cases/student_usecases/student_usecase.dart';
import 'package:sample_latest/features/schools/domain/use_cases/student_usecases/students_usecase.dart';
import 'package:sample_latest/features/schools/presentation/blocs/school_details_bloc/school_details_bloc.dart';
import 'package:sample_latest/features/schools/presentation/blocs/students_bloc/students_bloc.dart';

import '../../../core/data/base_service.dart';
import '../data/repository/schools_repository_impl.dart';
import '../domain/use_cases/schools_usecase/delete_school_usecase.dart';
import '../domain/use_cases/school_details_usecase/school_details_modify_useCase.dart';
import '../domain/use_cases/school_details_usecase/school_details_usecase.dart';
import '../domain/use_cases/schools_usecase/school_modify_usecase.dart';
import '../domain/use_cases/schools_usecase/school_usecase.dart';
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
            create: (BuildContext context) => SchoolsBloc(
              SchoolsUseCase(SchoolsRepositoryImpl(baseService), injector()),
              SchoolModifyUseCase(
                  SchoolsRepositoryImpl(baseService), injector()),
              DeleteSchoolUseCase(
                  SchoolsRepositoryImpl(baseService), injector()),
            ),
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
