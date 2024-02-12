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
  final int? id;
  final String schoolName;
  final String country;
  final String location;

  CreateSchoolEvent(this.schoolName, this.country, this.location, {this.id});
}

class CreateOrEditStudentEvent extends SchoolEvent {

   final StudentModel student;

   final int schoolId;

   CreateOrEditStudentEvent(this.student, this.schoolId);
}

class CreateOrEditSchoolDetailsEvent extends SchoolEvent {

  final SchoolDetailsModel schoolDetails;

  CreateOrEditSchoolDetailsEvent(this.schoolDetails);
}

class DeleteSchoolEvent extends SchoolEvent {

  final int schoolId;

  DeleteSchoolEvent(this.schoolId);
}

class DeleteStudentEvent extends SchoolEvent {

  final int schoolId;

  final int studentId;

  DeleteStudentEvent( this.studentId, this.schoolId);
}