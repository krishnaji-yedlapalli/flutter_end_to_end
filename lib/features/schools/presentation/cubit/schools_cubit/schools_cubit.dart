import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/analytics_exception_handler/exception_handler.dart';
import 'package:sample_latest/core/routing/routing_exports.dart';

import 'package:loader_overlay/loader_overlay.dart';
import 'package:sample_latest/features/schools/domain/entities/school_entity.dart';

import '../../../domain/use_cases/schools_usecase/delete_school_usecase.dart';
import '../../../domain/use_cases/schools_usecase/school_modify_usecase.dart';
import '../../../domain/use_cases/schools_usecase/school_usecase.dart';
import '../../../shared/models/school_view_model.dart';
import '../../../shared/params/school_params.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/data/utils/service_enums_typedef.dart';
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
        super(const SchoolsInfoInitial());

  final SchoolsUseCase _schoolUseCase;
  final SchoolModifyUseCase _schoolModifyUseCase;
  final DeleteSchoolUseCase _deleteSchoolUseCase;
  final SchoolsUiMapper _uiMapper;

  bool _isWelcomeMessageShown = false;

  void updateWelcomeMessageStatus(bool status) {
    _isWelcomeMessageShown = status;
  }

  Future<void> loadSchools() async {
    emit(SchoolsInfoLoading(isWelcomeMessageShown: _isWelcomeMessageShown));

    try {
      var schoolEntities = await _schoolUseCase.call();

      final uiModel = _uiMapper.convert(schoolEntities);

      emit(SchoolsInfoLoaded(uiModel));
    } catch (e, s) {
      emit(SchoolDataError(ExceptionHandler().handleException(e, s)));
    }
  }

  Future<void> createOrUpdateSchool(SchoolParams params,
      {bool isCreateSchool = false}) async {
    try {
      NavigationKeys.navigatorKey.currentContext?.loaderOverlay.show();

      var schoolEntities =
          await _schoolModifyUseCase.call(params, isCreateSchool);
      _updateSchools(schoolEntities);
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s,
          toastMessage: isCreateSchool
              ? 'Unable to create the School'
              : 'Unable to update the school');
    } finally {
      NavigationKeys.navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }

  Future<void> deleteSchool(String schoolId) async {
    try {
      NavigationKeys.navigatorKey.currentContext?.loaderOverlay.show();

      var schoolEntities = await _deleteSchoolUseCase.call(schoolId);
      _updateSchools(schoolEntities);
    } catch (e, s) {
      ExceptionHandler().handleExceptionWithToastNotifier(e,
          stackTrace: s, toastMessage: 'Failed to Delete the School');
    } finally {
      NavigationKeys.navigatorKey.currentContext?.loaderOverlay.hide();
    }
  }

  void _updateSchools(List<SchoolEntity> schoolEntities) {
    if (state is! SchoolsInfoLoaded) {
      return;
    }

    final currentState = state as SchoolsInfoLoaded;
    final updatedUiModel = currentState.schoolsUiModel
        .copyWith(schools: _uiMapper.mapToSchoolViewModels(schoolEntities));

    emit(SchoolsInfoLoaded(updatedUiModel));
  }
}
