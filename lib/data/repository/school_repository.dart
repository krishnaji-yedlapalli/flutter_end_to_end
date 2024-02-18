
import 'package:sample_latest/data/base_service.dart';
import 'package:sample_latest/data/models/school/school_details_model.dart';
import 'package:sample_latest/data/models/school/school_model.dart';
import 'package:sample_latest/data/models/school/student_model.dart';
import 'package:sample_latest/data/urls.dart';
import 'package:sample_latest/data/utils/enums.dart';
import 'package:sample_latest/utils/enums.dart';

abstract class SchoolRepo {
Future<SchoolDetailsModel?> fetchSchoolDetails(int id);
Future<List<SchoolModel>> fetchSchools();
Future<List<StudentModel>> fetchStudents(int schoolId);
Future<StudentModel> fetchStudent(int studentId, int schoolId);
Future<SchoolModel> createOrEditSchool(Map<String, dynamic> body);
Future<SchoolDetailsModel> addOrEditSchoolDetails(Map<String, dynamic> body);
Future<StudentModel?> createOrEditStudent(int schoolId, Map<String, dynamic> body);
Future<bool> deleteSchool(int id);
Future<bool> deleteStudent(int studentId, int schoolId);
}

class SchoolRepository extends BaseService implements SchoolRepo{

  @override
  Future<List<SchoolModel>> fetchSchools() async {
     List<SchoolModel> schools = <SchoolModel>[];
     var response = await makeRequest(url: '${Urls.schools}.json');
     if(response != null && response is List) {
       response.removeWhere((element) => element == null);
       schools = response.map<SchoolModel>((school) => SchoolModel.fromJson(school)).toList();
     }else if (response != null && response is Map){
       schools.add(SchoolModel.fromJson(response[response.keys.first]));
     }
     return schools;
  }

  @override
  Future<StudentModel> fetchStudent(int studentId, int schoolId) async {
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
  Future<SchoolDetailsModel?> fetchSchoolDetails(int id) async {
    SchoolDetailsModel? schoolDetails;
    var response = await makeRequest(url: '${Urls.schoolDetails}/$id.json');
    if(response != null) {
      schoolDetails = SchoolDetailsModel.fromJson(response);
    }
    return schoolDetails;
  }

  @override
  Future<List<StudentModel>> fetchStudents(int schoolId) async {
    List<StudentModel> students = <StudentModel>[];
    var response = await makeRequest(url: '${Urls.students}/$schoolId.json');
    if(response != null && response is List) {
      response.removeWhere((element) => element == null);
      students = response.map<StudentModel>((json) =>StudentModel.fromJson(json)).toList();
    } else if (response != null && response is Map){
      students.add(StudentModel.fromJson(response[response.keys.first]));
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
  Future<StudentModel?> createOrEditStudent(int schoolId, Map<String, dynamic> body) async {
    StudentModel? studentModel;

    var response = await makeRequest(url: '${Urls.students}/$schoolId.json', body: body, method: RequestType.patch);
    if(response != null && response is Map && response.keys.isNotEmpty) {
      studentModel = StudentModel.fromJson(response[response.keys.first]);
    }
    return studentModel;
  }

  @override
  Future<bool> deleteSchool(int schoolId) async {
    var schoolDelRes = await makeRequest(url: '${ Urls.schools}/$schoolId.json', method: RequestType.delete);
    var schoolDetailsDelRes = await makeRequest(url: '${Urls.schoolDetails}/$schoolId.json', method: RequestType.delete);
    var studentsDel = await makeRequest(url: '${Urls.students}/$schoolId.json', method: RequestType.delete);
   return true;
  }

  @override
  Future<bool> deleteStudent(int studentId, int schoolId) async {
    var studentsDel = await makeRequest(url: '${Urls.students}/$schoolId/$studentId.json', method: RequestType.delete);
    return true;
  }



}