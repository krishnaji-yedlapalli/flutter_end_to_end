import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import 'package:app_core/core/data/utils/service_enums_typedef.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/use_cases/use_cases.dart';
import '../../../shared/params/school_params.dart';
import '../../ui_mappers/schools_ui_mapper.dart';
import '../../ui_models/schools_ui_model.dart';

part 'schools_state.dart';

class SchoolsCubit extends Cubit<SchoolsState> {
  SchoolsCubit(
      {required SchoolsUseCase schoolsUseCase,
      required SchoolModifyUseCase schoolModifyUseCase,
      required DeleteSchoolUseCase deleteSchoolUsecase,
      required SchoolsUiMapper uiMapper})
      : _schoolUseCase = schoolsUseCase,
        _schoolModifyUseCase = schoolModifyUseCase,
        _deleteSchoolUseCase = deleteSchoolUsecase,
        _uiMapper = uiMapper,
        super(const SchoolsInfoLoading());

  final SchoolsUseCase _schoolUseCase;
  final SchoolModifyUseCase _schoolModifyUseCase;
  final DeleteSchoolUseCase _deleteSchoolUseCase;
  final SchoolsUiMapper _uiMapper;

  Future<void> loadSchools() async {
    /// Loading labels
    final uiModel = _uiMapper.convert([]);
    emit(SchoolsInfoInitial(uiModel));

    var result = await _schoolUseCase.call();

    switch (result) {
      case Left(value: final schoolEntities):
        final uiModel = _uiMapper.convert(schoolEntities);

        emit(SchoolsInfoLoaded(uiModel));
      case Right(value: final errorDetails):
        emit(SchoolDataError(errorDetails));
    }
  }

  Future<void> createOrUpdateSchool(SchoolParams params,
      {bool isCreateSchool = false}) async {
    if (state is! SchoolsInfoLoaded) {
      return;
    }
    final previousState = state as SchoolsInfoLoaded;

    emit(const SchoolsInfoOverlayLoading(isLoading: true));

    var result = await _schoolModifyUseCase.call(params, isCreateSchool);

    emit(const SchoolsInfoOverlayLoading(isLoading: false));

    switch (result) {
      case Left(value: final schoolEntities):
        _updateSchools(
            prevUiModel: previousState.schoolsUiModel,
            schoolEntities: schoolEntities);

      case _: // Do nothing
    }
  }

  Future<void> deleteSchool(String schoolId) async {
    if (state is! SchoolsInfoLoaded) {
      return;
    }
    final previousState = state as SchoolsInfoLoaded;

    emit(const SchoolsInfoOverlayLoading(isLoading: true));

    var result = await _deleteSchoolUseCase.call(schoolId);
    emit(const SchoolsInfoOverlayLoading(isLoading: false));

    switch (result) {
      case Left(value: final schoolEntities):
        _updateSchools(
            prevUiModel: previousState.schoolsUiModel,
            schoolEntities: schoolEntities);

      case _: // Do nothing
    }
  }

  void _updateSchools(
      {required SchoolsUiModel prevUiModel,
      required List<SchoolEntity> schoolEntities}) {
    final updatedUiModel = prevUiModel.copyWith(
        schools: _uiMapper.mapToSchoolViewModels(schoolEntities));

    emit(SchoolsInfoLoaded(updatedUiModel));
  }
}
