
import 'package:sample_latest/data/base_service.dart';
import 'package:sample_latest/data/models/school/school_details_model.dart';
import 'package:sample_latest/data/models/school/school_model.dart';
import 'package:sample_latest/data/models/school/student_model.dart';
import 'package:sample_latest/data/urls.dart';
import 'package:sample_latest/utils/enums.dart';

abstract class SchoolRepo {
Future<SchoolDetailsModel?> fetchSchoolDetails(int id);
Future<List<SchoolModel>> fetchSchools();
Future<List<StudentModel>> fetchStudents(int schoolId);
Future<StudentModel> fetchStudent(int studentId, int schoolId);
Future<SchoolModel> createSchool(Map<String, dynamic> body);
Future<bool> addSchoolDetails(Map<String, dynamic> body);
Future<StudentModel?> createStudent(int schoolId, Map<String, dynamic> body);
Future<bool> deleteSchool(String id);
}

class SchoolRepository extends BaseService implements SchoolRepo{

  @override
  Future<List<SchoolModel>> fetchSchools() async {
     List<SchoolModel> schools = <SchoolModel>[];
     var response = await makeRequest(url: Urls.schools);
     if(response != null) {
       schools = response.map<SchoolModel>((school) => SchoolModel.fromJson(school)).toList();
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
    List<StudentModel> students;
    var response = await makeRequest(url: '${Urls.students}/$schoolId.json');
    if(response != null) {
      students = response.map<StudentModel>((json) =>StudentModel.fromJson(json)).toList();
    }else {
      throw Exception();
    }
    return students;
  }

  @override
  Future<bool> addSchoolDetails(Map<String, dynamic> body) {
    // TODO: implement addSchoolDetails
    throw UnimplementedError();
  }

  @override
  Future<SchoolModel> createSchool(Map<String, dynamic> body) async {
    SchoolModel schoolDetails;

    var response = await makeRequest(url: Urls.schools, body: body, method: RequestType.patch);
    if(response != null && response is Map && response.keys.isNotEmpty) {
      schoolDetails = SchoolModel.fromJson(response[response.keys.first]);
    }else{
      throw UnimplementedError();
    }
    return schoolDetails;
  }

  @override
  Future<StudentModel?> createStudent(int schoolId, Map<String, dynamic> body) async {
    StudentModel? studentModel;

    var response = await makeRequest(url: '${Urls.students}/$schoolId.json', body: body, method: RequestType.patch);
    if(response != null && response is Map && response.keys.isNotEmpty) {
      studentModel = StudentModel.fromJson(response[response.keys.first]);
    }
    return studentModel;
  }

  @override
  Future<bool> deleteSchool(String id) {
    // TODO: implement deleteSchool
    throw UnimplementedError();
  }

}