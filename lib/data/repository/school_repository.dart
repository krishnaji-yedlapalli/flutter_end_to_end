
import 'package:sample_latest/data/base_service.dart';
import 'package:sample_latest/data/models/school/school_model.dart';
import 'package:sample_latest/data/models/school/student_model.dart';
import 'package:sample_latest/data/urls.dart';

abstract class SchoolRepo {
Future<SchoolModel> fetchSchoolDetails();
Future<List<SchoolModel>> fetchSchools();
Future<StudentModel> fetchStudent();
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
  Future<StudentModel> fetchStudent() async {
    StudentModel student;
    var response = await makeRequest(url: Urls.students);
    if(response != null) {
      student = StudentModel.fromJson(response);
    }else {
      throw Exception();
    }
    return student;
  }

  @override
  Future<SchoolModel> fetchSchoolDetails() async {
    SchoolModel school;
    var response = await makeRequest(url: Urls.schools);
    if(response != null) {
      school = response.map<SchoolModel>((school) => SchoolModel.fromJson(school)).toList().first;
    }else{
      throw UnimplementedError();
    }
    return school;
  }

}