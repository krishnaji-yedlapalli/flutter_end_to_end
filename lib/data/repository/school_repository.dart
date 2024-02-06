
import 'package:sample_latest/data/base_service.dart';
import 'package:sample_latest/data/models/school/school_details_model.dart';
import 'package:sample_latest/data/models/school/school_model.dart';
import 'package:sample_latest/data/models/school/student_model.dart';
import 'package:sample_latest/data/urls.dart';

abstract class SchoolRepo {
Future<SchoolDetailsModel> fetchSchoolDetails(int id);
Future<List<SchoolModel>> fetchSchools();
Future<List<StudentModel>> fetchStudents(int schoolId);
Future<StudentModel> fetchStudent(int studentId, int schoolId);
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
  Future<SchoolDetailsModel> fetchSchoolDetails(int id) async {
    SchoolDetailsModel schoolDetails;
    var response = await makeRequest(url: '${Urls.schoolDetails}/$id.json');
    if(response != null) {
      schoolDetails = SchoolDetailsModel.fromJson(response);
    }else{
      throw UnimplementedError();
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

}