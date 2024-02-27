
import 'package:sample_latest/data/base_service.dart';
import 'package:sample_latest/data/models/school/school_details_model.dart';
import 'package:sample_latest/data/models/school/school_model.dart';
import 'package:sample_latest/data/models/school/student_model.dart';
import 'package:sample_latest/data/urls.dart';
import 'package:sample_latest/data/utils/enums.dart';
import 'package:sample_latest/utils/enums.dart';

abstract class SchoolRepo {
Future<SchoolDetailsModel?> fetchSchoolDetails(String id);
Future<List<SchoolModel>> fetchSchools();
Future<List<StudentModel>> fetchStudents(String schoolId);
Future<StudentModel> fetchStudent(String studentId, String schoolId);
Future<SchoolModel> createOrEditSchool(Map<String, dynamic> body);
Future<SchoolDetailsModel> addOrEditSchoolDetails(Map<String, dynamic> body);
Future<StudentModel?> createOrEditStudent(String schoolId, Map<String, dynamic> body);
Future<bool> deleteSchool(String id);
Future<bool> deleteStudent(String studentId, String schoolId);
}

class SchoolRepository with BaseService implements SchoolRepo{

  @override
  Future<List<SchoolModel>> fetchSchools() async {
     List<SchoolModel> schools = <SchoolModel>[];
     var response = await makeRequest(url: '${Urls.schools}.json');
     if(response is Map) {
       schools = response.entries.map<SchoolModel>((json) => SchoolModel.fromJson(json.value)).toList();
     }else if(response is List){
       schools = response.map<SchoolModel>((json) => SchoolModel.fromJson(json)).toList();
     }
     return schools;
  }

  @override
  Future<StudentModel> fetchStudent(String studentId, String schoolId) async {
    StudentModel student;
    var response = await makeRequest(url: '${Urls.students}/$schoolId/$studentId.json');
    if(response != null) {
      student = StudentModel.fromJson(response);
    }else {
      throw Exception();
    }
    return student;
  }

  @override
  Future<SchoolDetailsModel?> fetchSchoolDetails(String id) async {
    SchoolDetailsModel? schoolDetails;
    var response = await makeRequest(url: '${Urls.schoolDetails}/$id.json');
    if(response != null) {
      schoolDetails = SchoolDetailsModel.fromJson(response);
    }
    return schoolDetails;
  }

  @override
  Future<List<StudentModel>> fetchStudents(String schoolId) async {
    List<StudentModel> students = <StudentModel>[];
    var response = await makeRequest(url: '${Urls.students}/$schoolId.json');
    if(response is Map) {
      students = response.entries.map<StudentModel>((json) => StudentModel.fromJson(json.value)).toList();
    }else if( response is List){
      students = response.map<StudentModel>((json) => StudentModel.fromJson(json)).toList();
    }
    return students;
  }

  @override
  Future<SchoolDetailsModel> addOrEditSchoolDetails(Map<String, dynamic> body) async {
    SchoolDetailsModel schoolDetails;

    var response = await makeRequest(url: '${Urls.schoolDetails}.json', body: body, method: RequestType.patch);
    if(response != null && response is Map && response.keys.isNotEmpty) {
      schoolDetails = SchoolDetailsModel.fromJson(response[response.keys.first]);
    }else{
      throw UnimplementedError();
    }
    return schoolDetails;
  }

  @override
  Future<SchoolModel> createOrEditSchool(Map<String, dynamic> body) async {
    SchoolModel schoolDetails;

    var response = await makeRequest(url: '${Urls.schools}.json', body: body, method: RequestType.patch);
    if(response != null && response is Map && response.keys.isNotEmpty) {
      schoolDetails = SchoolModel.fromJson(response[response.keys.first]);
    }else{
      throw UnimplementedError();
    }
    return schoolDetails;
  }

  @override
  Future<StudentModel?> createOrEditStudent(String schoolId, Map<String, dynamic> body) async {
    StudentModel? studentModel;

    var response = await makeRequest(url: '${Urls.students}/$schoolId.json', body: body, method: RequestType.patch);
    if(response != null && response is Map && response.keys.isNotEmpty) {
      studentModel = StudentModel.fromJson(response[response.keys.first]);
    }
    return studentModel;
  }

  @override
  Future<bool> deleteSchool(String schoolId) async {
    var schoolDelRes = await makeRequest(url: '${ Urls.schools}/$schoolId.json', method: RequestType.delete);
    var schoolDetailsDelRes = await makeRequest(url: '${Urls.schoolDetails}/$schoolId.json', method: RequestType.delete);
    var studentsDel = await makeRequest(url: '${Urls.students}/$schoolId.json', method: RequestType.delete);
   return true;
  }

  @override
  Future<bool> deleteStudent(String studentId, String schoolId) async {
    var studentsDel = await makeRequest(url: '${Urls.students}/$schoolId/$studentId.json', method: RequestType.delete);
    return true;
  }



}