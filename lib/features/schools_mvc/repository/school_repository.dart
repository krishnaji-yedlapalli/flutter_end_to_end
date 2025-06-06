import 'package:sample_latest/core/data/base_service.dart';
import 'package:sample_latest/features/schools/data/model/school_details_model.dart';
import 'package:sample_latest/features/schools/data/model/school_model.dart';
import 'package:sample_latest/features/schools/data/model/student_model.dart';
import 'package:sample_latest/core/data/urls.dart';
import 'package:sample_latest/core/data/utils/service_enums_typedef.dart';

abstract class SchoolRepo {
  Future<SchoolDetailsModel?> fetchSchoolDetails(String id);
  Future<List<SchoolModel>> fetchSchools();
  Future<List<StudentModel>> fetchStudents(String schoolId);
  Future<StudentModel?> fetchStudent(String studentId, String schoolId);
  Future<SchoolModel> createOrEditSchool(SchoolModel school);
  Future<SchoolDetailsModel> addOrEditSchoolDetails(
      SchoolDetailsModel schoolDetails);
  Future<StudentModel> createOrEditStudent(
      String schoolId, StudentModel student);
  Future<bool> deleteSchool(String id);
  Future<bool> deleteStudent(String studentId, String schoolId);
}

class SchoolRepository extends SchoolRepo {
  final BaseService baseService;

  SchoolRepository({BaseService? baseService})
      : baseService = baseService ?? BaseService.instance;

  @override
  Future<List<SchoolModel>> fetchSchools() async {
    List<SchoolModel> schools = <SchoolModel>[];
    var response = await baseService.makeRequest(url: '${Urls.schools}.json');
    if (response is Map) {
      schools = response.entries
          .map<SchoolModel>((json) => SchoolModel.fromJson(json.value))
          .toList();
    } else if (response is List) {
      schools = response
          .map<SchoolModel>((json) => SchoolModel.fromJson(json))
          .toList();
    }
    return schools;
  }

  @override
  Future<StudentModel?> fetchStudent(String studentId, String schoolId) async {
    StudentModel? student;
    var response = await baseService.makeRequest(
        url: '${Urls.students}/$schoolId/$studentId.json');
    if (response != null) {
      student = StudentModel.fromJson(response);
    }
    return student;
  }

  @override
  Future<SchoolDetailsModel?> fetchSchoolDetails(String id) async {
    SchoolDetailsModel? schoolDetails;
    var response =
        await baseService.makeRequest(url: '${Urls.schoolDetails}/$id.json');
    if (response != null) {
      schoolDetails = SchoolDetailsModel.fromJson(response);
    }
    return schoolDetails;
  }

  @override
  Future<List<StudentModel>> fetchStudents(String schoolId) async {
    List<StudentModel> students = <StudentModel>[];
    var response =
        await baseService.makeRequest(url: '${Urls.students}/$schoolId.json');
    if (response is Map) {
      students = response.entries
          .map<StudentModel>((json) => StudentModel.fromJson(json.value))
          .toList();
    } else if (response is List) {
      students = response
          .map<StudentModel>((json) => StudentModel.fromJson(json))
          .toList();
    }
    return students;
  }

  @override
  Future<SchoolDetailsModel> addOrEditSchoolDetails(
      SchoolDetailsModel schoolDetails) async {
    Map<String, dynamic> body = {schoolDetails.id: schoolDetails.toJson()};

    var response = await baseService.makeRequest(
        url: '${Urls.schoolDetails}.json',
        body: body,
        method: RequestType.patch);
    if (response != null && response is Map && response.keys.isNotEmpty) {
      schoolDetails =
          SchoolDetailsModel.fromJson(response[response.keys.first]);
    } else {
      throw UnimplementedError();
    }
    return schoolDetails;
  }

  @override
  Future<SchoolModel> createOrEditSchool(SchoolModel school) async {
    Map<String, dynamic> body = {school.id: school.toJson()};

    var response = await baseService.makeRequest(
        url: '${Urls.schools}.json', body: body, method: RequestType.patch);
    if (response != null && response is Map && response.keys.isNotEmpty) {
      school = SchoolModel.fromJson(response[response.keys.first]);
    } else {
      throw UnimplementedError();
    }
    return school;
  }

  @override
  Future<StudentModel> createOrEditStudent(
      String schoolId, StudentModel student) async {
    Map<String, dynamic> body = {student.id: student.toJson()};

    var response = await baseService.makeRequest(
        url: '${Urls.students}/$schoolId.json',
        body: body,
        method: RequestType.patch);
    if (response != null && response is Map && response.keys.isNotEmpty) {
      student = StudentModel.fromJson(response[response.keys.first]);
    }
    return student;
  }

  @override
  Future<bool> deleteSchool(String schoolId) async {
    var schoolDelRes = await baseService.makeRequest(
        url: '${Urls.schools}/$schoolId.json', method: RequestType.delete);
    var schoolDetailsDelRes = await baseService.makeRequest(
        url: '${Urls.schoolDetails}/$schoolId.json',
        method: RequestType.delete);
    var studentsDel = await baseService.makeRequest(
        url: '${Urls.students}/$schoolId.json', method: RequestType.delete);
    return true;
  }

  @override
  Future<bool> deleteStudent(String studentId, String schoolId) async {
    var studentsDel = await baseService.makeRequest(
        url: '${Urls.students}/$schoolId/$studentId.json',
        method: RequestType.delete);
    return true;
  }
}
