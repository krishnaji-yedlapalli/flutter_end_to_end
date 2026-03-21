import 'package:get_it/get_it.dart';
import 'package:sample_latest/core/data/base_service.dart';
import 'package:sample_latest/features/schools/shared/models/school_executed_task_model.dart';

import '../data/repository/repository.dart';
import '../domain/repository/repository.dart';
import '../domain/use_cases/use_cases.dart';
import '../presentation/cubit/school_details_bloc/school_details_bloc.dart';
import '../presentation/cubit/schools_cubit/schools_cubit.dart';
import '../presentation/cubit/students_bloc/students_bloc.dart';
import '../presentation/ui_mappers/schools_ui_mapper.dart';

class SchoolsInjectionModule {
  SchoolsInjectionModule._();

  static final SchoolsInjectionModule _instance = SchoolsInjectionModule._();

  factory SchoolsInjectionModule() => _instance;

  final GetIt injector = GetIt.instance;

  Future<void> registerDependencies() async {
    _registerCore();
    _registerRepositories();
    _registerUseCases();
    _registerBlocs();
  }

  void _registerCore() {
    if (!injector.isRegistered<SchoolExecutedTaskFlow>()) {
      injector
          .registerSingleton<SchoolExecutedTaskFlow>(SchoolExecutedTaskFlow());
    }
    if (!injector.isRegistered<SchoolsUiMapper>()) {
      injector.registerSingleton<SchoolsUiMapper>(SchoolsUiMapperImp());
    }
  }

  void _registerRepositories() {
    var baseService = BaseService.instance;

    if (!injector.isRegistered<SchoolRepository>()) {
      injector.registerLazySingleton<SchoolRepository>(
          () => SchoolsRepositoryImpl(baseService));
    }
    if (!injector.isRegistered<SchoolDetailsRepository>()) {
      injector.registerLazySingleton<SchoolDetailsRepository>(
          () => SchoolsDetailsRepositoryImpl(baseService));
    }
    if (!injector.isRegistered<StudentsRepository>()) {
      injector.registerLazySingleton<StudentsRepository>(
          () => StudentsRepositoryImpl(baseService));
    }
  }

  void _registerUseCases() {
    if (!injector.isRegistered<SchoolsUseCase>()) {
      injector.registerFactory<SchoolsUseCase>(
          () => SchoolsUseCase(injector(), injector()));
    }
    if (!injector.isRegistered<SchoolModifyUseCase>()) {
      injector.registerFactory<SchoolModifyUseCase>(
          () => SchoolModifyUseCase(injector(), injector()));
    }
    if (!injector.isRegistered<DeleteSchoolUseCase>()) {
      injector.registerFactory<DeleteSchoolUseCase>(
          () => DeleteSchoolUseCase(injector(), injector()));
    }
    if (!injector.isRegistered<SchoolDetailsUseCase>()) {
      injector.registerFactory<SchoolDetailsUseCase>(
          () => SchoolDetailsUseCase(injector(), injector()));
    }
    if (!injector.isRegistered<SchoolDetailsModifyUseCase>()) {
      injector.registerFactory<SchoolDetailsModifyUseCase>(
          () => SchoolDetailsModifyUseCase(injector(), injector()));
    }
    if (!injector.isRegistered<StudentsUseCase>()) {
      injector.registerFactory<StudentsUseCase>(
          () => StudentsUseCase(injector(), injector()));
    }
    if (!injector.isRegistered<StudentUseCase>()) {
      injector.registerFactory<StudentUseCase>(
          () => StudentUseCase(injector(), injector()));
    }
    if (!injector.isRegistered<StudentModifyUseCase>()) {
      injector.registerFactory<StudentModifyUseCase>(
          () => StudentModifyUseCase(injector(), injector()));
    }
    if (!injector.isRegistered<DeleteStudentUseCase>()) {
      injector.registerFactory<DeleteStudentUseCase>(
          () => DeleteStudentUseCase(injector(), injector()));
    }
  }

  void _registerBlocs() {
    if (!injector.isRegistered<StudentsBloc>()) {
      injector.registerFactory<StudentsBloc>(
          () => StudentsBloc(injector(), injector(), injector(), injector()));
    }
    if (!injector.isRegistered<SchoolsCubit>()) {
      injector.registerFactory<SchoolsCubit>(() => SchoolsCubit(
          schoolsUseCase: injector(),
          schoolModifyUseCase: injector(),
          deleteSchoolUsecase: injector(),
          uiMapper: injector()));
    }
    if (!injector.isRegistered<SchoolDetailsBloc>()) {
      injector.registerFactory<SchoolDetailsBloc>(
          () => SchoolDetailsBloc(injector(), injector(), injector()));
    }
  }

  void unRegisterDependencies() async {
    await injector.unregister<SchoolExecutedTaskFlow>();
    await injector.unregister<SchoolsUiMapper>();
    await injector.unregister<SchoolRepository>();
    await injector.unregister<SchoolDetailsRepository>();
    await injector.unregister<StudentsRepository>();
    await injector.unregister<SchoolsUseCase>();
    await injector.unregister<SchoolModifyUseCase>();
    await injector.unregister<DeleteSchoolUseCase>();
    await injector.unregister<SchoolDetailsUseCase>();
    await injector.unregister<SchoolDetailsModifyUseCase>();
    await injector.unregister<StudentsUseCase>();
    await injector.unregister<StudentUseCase>();
    await injector.unregister<StudentModifyUseCase>();
    await injector.unregister<DeleteStudentUseCase>();
    await injector.unregister<StudentsBloc>();
    await injector.unregister<SchoolsCubit>();
    await injector.unregister<SchoolDetailsBloc>();
  }
}
