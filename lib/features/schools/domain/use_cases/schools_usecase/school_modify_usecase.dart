import '../../../../../core/mixins/helper_methods.dart';
import '../../../shared/models/school_executed_task_model.dart';
import '../../../shared/params/school_params.dart';
import '../../entities/school_entity.dart';
import '../../repository/school_repository.dart';

class SchoolModifyUseCase {
  SchoolModifyUseCase(this._repository, this._executedTask);

  final SchoolRepository _repository;

  final SchoolExecutedTaskFlow _executedTask;

  Future<List<SchoolEntity>> call(
      SchoolParams params, bool isCreateSchool) async {
    var schools = <SchoolEntity>[];

    if (isCreateSchool) {
      schools = await createSchool(params);
    } else {
      schools = await updateSchool(params);
    }

    return schools;
  }

  Future<List<SchoolEntity>> createSchool(SchoolParams params) async {
    var school = SchoolEntity(
        params.schoolName,
        params.country,
        params.location,

        /// Adding unique id
        HelperMethods.uuid,

        /// created date
        DateTime.now().millisecondsSinceEpoch);

    var createdSchool = await _repository.createOrEditSchool(school);

    _executedTask.schools.add(createdSchool);
    return _executedTask.schools;
  }

  Future<List<SchoolEntity>> updateSchool(SchoolParams params) async {
    var school =
        _executedTask.schools.firstWhere((school) => school.id == params.id);

    school = school.copyWith(
        schoolName: params.schoolName,
        country: params.country,
        location: params.location,
        updatedDate: DateTime.now().millisecondsSinceEpoch);

    var updatedSchool = await _repository.createOrEditSchool(school);

    _executedTask.schools = _executedTask.schools
        .map((s) => s.id == school.id ? updatedSchool : s)
        .toList();

    return _executedTask.schools;
  }
}
