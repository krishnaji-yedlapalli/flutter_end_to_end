import 'package:sample_latest/core/data/network/network_client.dart';
import 'package:sample_latest/core/data/urls.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';
import 'package:schools/domain/entities/entities.dart';

import '../../domain/repository/repository.dart';
import '../model/student_model.dart';

class StudentsRepositoryImpl implements StudentsRepository {
  StudentsRepositoryImpl(this._networkClient);

  final NetworkClient _networkClient;

  @override
  Future<StudentEntity?> fetchStudent(String studentId, String schoolId) async {
    StudentEntity? student;
    final result = await _networkClient.makeRequest(
        url: '${Urls.students}/$schoolId/$studentId');

    return result.fold(
      (failure) => null,
      (response) {
        final data = response.data;
        if (data != null) {
          student = StudentModel.fromJson(data).toEntity();
        }
        return student;
      },
    );
  }

  @override
  Future<List<StudentEntity>> fetchStudents(String schoolId) async {
    List<StudentEntity> students = <StudentEntity>[];
    final result =
        await _networkClient.makeRequest(url: '${Urls.students}/$schoolId');

    return result.fold(
      (failure) => students,
      (response) {
        final data = response.data;
        if (data is Map) {
          students = data.entries
              .map<StudentEntity>(
                  (json) => StudentModel.fromJson(json.value).toEntity())
              .toList();
        } else if (data is List) {
          students = data
              .map<StudentEntity>(
                  (json) => StudentModel.fromJson(json).toEntity())
              .toList();
        }
        return students;
      },
    );
  }

  @override
  Future<StudentEntity> createOrEditStudent(StudentEntity student) async {
    Map<String, dynamic> body = {
      student.id: StudentModel.fromEntity(student).toJson()
    };

    final result = await _networkClient.makeRequest(
        url: '${Urls.students}/${student.schoolId}',
        body: body,
        method: RequestType.patch);

    return result.fold(
      (failure) =>
          throw Exception(failure.message ?? 'Failed to create/edit student'),
      (response) {
        final data = response.data;
        if (data != null && data is Map && data.keys.isNotEmpty) {
          student = StudentModel.fromJson(data[data.keys.first]).toEntity();
        }
        return student;
      },
    );
  }

  @override
  Future<bool> deleteStudent(String studentId, String schoolId) async {
    await _networkClient.makeRequest(
        url: '${Urls.students}/$schoolId/$studentId',
        method: RequestType.delete);
    return true;
  }
}
