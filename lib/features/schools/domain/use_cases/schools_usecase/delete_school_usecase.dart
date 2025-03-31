import '../../../shared/models/school_executed_task_model.dart';
import '../../entities/school_entity.dart';
import '../../repository/school_repository.dart';

class DeleteSchoolUseCase {
  DeleteSchoolUseCase(this._repository, this._executedTask);

  final SchoolRepository _repository;

  final SchoolExecutedTaskFlow _executedTask;

  Future<List<SchoolEntity>> call(String schoolId) async {
    var deletedSchool = await _repository.deleteSchool(schoolId);

    _executedTask.schools.removeWhere((s) => s.id == schoolId);

    return _executedTask.schools;
  }
}
