import '../../../shared/models/school_executed_task_model.dart';
import '../../entities/school_entity.dart';
import '../../repository/school_repository.dart';

class SchoolsUseCase {
  SchoolsUseCase(this._repository, this._executedTask);

  final SchoolRepository _repository;

  final SchoolExecutedTaskFlow _executedTask;

  Future<List<SchoolEntity>> call() async {
    var schools = await _repository.fetchSchools();
    _executedTask.schools = schools;
    return schools;
  }
}
