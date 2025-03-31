
import 'package:sample_latest/features/schools/domain/entities/student_entity.dart';

import '../../../../core/data/base_service.dart';
import '../../../../core/data/urls.dart';
import '../../../../core/data/utils/service_enums_typedef.dart';
import '../../domain/repository/students_repository.dart';
import '../model/student_model.dart';

class StudentsRepositoryImpl implements StudentsRepository {

  StudentsRepositoryImpl(this.baseService);

  final BaseService baseService;

  @override
  Future<StudentEntity?> fetchStudent(String studentId, String schoolId) async {
    StudentEntity? student;
    var response = await baseService.makeRequest(url: '${Urls.students}/$schoolId/$studentId.json');
    if(response != null) {
      student = StudentModel.fromJson(response).toEntity();
    }
    return student;
  }

  @override
  Future<List<StudentEntity>> fetchStudents(String schoolId) async {
    List<StudentEntity> students = <StudentEntity>[];
    var response = await baseService.makeRequest(url: '${Urls.students}/$schoolId.json');
    if(response is Map) {
      students = response.entries.map<StudentEntity>((json) => StudentModel.fromJson(json.value).toEntity()).toList();
    }else if(response is List){
      students = response.map<StudentEntity>((json) => StudentModel.fromJson(json).toEntity()).toList();
    }
    return students;
  }

  @override
  Future<StudentEntity> createOrEditStudent(StudentEntity student) async {

    Map<String, dynamic> body = {
      student.id: student.toModel().toJson()
    };

    var response = await baseService.makeRequest(url: '${Urls.students}/${student.schoolId}.json', body: body, method: RequestType.patch);
    if(response != null && response is Map && response.keys.isNotEmpty) {
      student = StudentModel.fromJson(response[response.keys.first]).toEntity();
    }
    return student;
  }

  @override
  Future<bool> deleteStudent(String studentId, String schoolId) async {
    var studentsDel = await baseService.makeRequest(url: '${Urls.students}/$schoolId/$studentId.json', method: RequestType.delete);
    return true;
  }
}