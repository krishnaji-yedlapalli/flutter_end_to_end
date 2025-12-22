import '../../domain/entities/school_entity.dart';
import '../../shared/models/school_view_model.dart';
import '../ui_models/schools_ui_model.dart';

abstract class SchoolsUiMapper {
  SchoolsUiModel convert(List<SchoolEntity> schools);
  List<SchoolViewModel> mapToSchoolViewModels(List<SchoolEntity> schools);
}

class SchoolsUiMapperImp extends SchoolsUiMapper {
  @override
  SchoolsUiModel convert(List<SchoolEntity> schoolEntities) {
    return SchoolsUiModel(
      header: 'Schools',
      filterByLabel: 'School Type',
      searchLabel: 'Search by name',
      schools: mapToSchoolViewModels(schoolEntities),
    );
  }

  @override
  List<SchoolViewModel> mapToSchoolViewModels(
      List<SchoolEntity> schoolEntities) {
    return schoolEntities
        .map((school) => SchoolViewModel.fromEntity(school))
        .toList();
  }
}
