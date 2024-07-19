import 'package:sample_latest/models/school/school_details_model.dart';
import 'package:sample_latest/models/school/school_model.dart';
import 'package:sample_latest/models/school/student_model.dart';

class SchoolMockData {
  static final List<SchoolModel> schools = [
    SchoolModel('Oxford', 'India', 'Noida', '52a29100b99c1023a3674150b7ab5f7b',
        1718168534634),
    SchoolModel('Kennedy', 'India', 'Noida', '52a29100b99c1023a3674150b7aa5f7b',
        1718168534634),
    SchoolModel('Delhi', 'India', 'Noida', '52a29100b99c1023a3674150b7ah5f7b',
        1718168534634),
    SchoolModel('Cambridge', 'India', 'Noida',
        '52a29100b99c1023a3674150b7a35f7b', 1718168534634),
    SchoolModel('Infrasonic', 'India', 'Noida',
        '52a29100b99c1023a3674150b7a75f7b', 1718168534634),
    SchoolModel('Model school', 'India', 'Noida',
        '52a29100b99c1023a3674150b7a15f7b', 1718168534634),
    SchoolModel('Model school', 'India', 'Noida',
        '52a29100b92c1023a3674150b7a15f7b', 1718168534634),
    SchoolModel('Model school', 'India', 'Noida',
        '52a29100b3c1023a3674150b7a15f7b', 1718168534634),
    SchoolModel('Model school', 'India', 'Noida',
        '52a29100699c1023a3674150b7a15f7b', 1718168534634),
    SchoolModel('Model school', 'India', 'Noida',
        '52a29100b69c1023a3674150b7a15f7b', 1718168534634),
    SchoolModel('Model school', 'India', 'Noida',
        '52a29100b97c1023a3674150b7a15f7b', 1718168534634),
    SchoolModel('Model school', 'India', 'Noida',
        '52a29100b99h1023a3674150b7a15f7b', 1718168534634),
    SchoolModel('Sanfransico', 'India', 'Noida',
        '52a29100b99c7023a3674150b7a15f7b', 1718168534634),
  ];

  static final students = [
    StudentModel('321', '123', 'john', 'texas', 'LKG', 1234567, updatedDate: 432211),
    StudentModel('234', '123', 'john', 'texas', 'LKG', 1234567, updatedDate: 432211),
    StudentModel('654', '123', 'john', 'texas', 'LKG', 1234567, updatedDate: 432211),
    StudentModel('789', '123', 'john', 'texas', 'LKG', 1234567, updatedDate: 432211),
    StudentModel('234', '123', 'john', 'texas', 'LKG', 1234567, updatedDate: 432211),
    StudentModel('654', '123', 'john', 'texas', 'LKG', 1234567, updatedDate: 432211),
    StudentModel('123', '123', 'john', 'texas', 'LKG', 1234567, updatedDate: 432211),
    StudentModel('765', '123', 'john', 'texas', 'LKG', 1234567, updatedDate: 432211),
    StudentModel('77', '123', 'john', 'texas', 'LKG', 1234567, updatedDate: 432211),
    StudentModel('345', '123', 'john', 'texas', 'LKG', 1234567, updatedDate: 432211),
    StudentModel('87543', '123', 'john', 'texas', 'LKG', 1234567, updatedDate: 432211),
    StudentModel('234', '123', 'john', 'texas', 'LKG', 1234567, updatedDate: 432211),
    StudentModel('987', '123', 'Ramesh', 'texas', 'LKG', 1234567, updatedDate: 432211),
  ];

  static final individualStudent = StudentModel('87905', '123', 'David', 'texas', 'LKG', 1234567, updatedDate: 432211);

  static final schoolDetails = SchoolDetailsModel('123', 'Oxford', 'India', 'Noida', 'https://upload.wikimedia.org/wikipedia/commons/c/ce/Monroe_Township_High_School_Front_View.jpg', 1200, 50, false, 1718168534634);

  static final schoolsJson = {
    "160eeb80b9441071a5ac59e962588b3e": {
      "country": "USA",
      "createdDate": 1720364001555,
      "id": "160eeb80b9441071a5ac59e962588b3e",
      "location": "1",
      "schoolName": "Kennedy",
      "updatedDate": 1720364001555
    },
    "b4a8e200d4d81071b7c5c57a371abf3f": {
      "country": "Dubai",
      "createdDate": 1720367034069,
      "id": "b4a8e200d4d81071b7c5c57a371abf3f",
      "location": "Hyd",
      "schoolName": "Oxford",
      "updatedDate": 1720367034069
    }
  };
}
