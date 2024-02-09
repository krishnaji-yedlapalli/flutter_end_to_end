part of 'school_bloc.dart';


@immutable
abstract class SchoolEvent {

}

class SchoolsDataEvent extends SchoolEvent {
  SchoolsDataEvent();
}

class SchoolDataEvent extends SchoolEvent {
  final int id;
  SchoolDataEvent(this.id);
}

class StudentsDataEvent extends SchoolEvent {
  final int schoolId;
  StudentsDataEvent(this.schoolId);
}

class StudentDataEvent extends SchoolEvent {
  final int studentId;
  final int schoolId;
  StudentDataEvent(this.studentId, this.schoolId);
}

class CreateSchoolEvent extends SchoolEvent {
  final String schoolName;
  final String country;
  final String location;

  CreateSchoolEvent(this.schoolName, this.country, this.location);
}

class CreateStudentEvent extends SchoolEvent {

   final StudentModel student;

   final int schoolId;

   CreateStudentEvent(this.student, this.schoolId);
}