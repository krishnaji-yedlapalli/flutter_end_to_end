part of 'school_bloc.dart';


@immutable
abstract class SchoolEvent {

}

class SchoolsDataEvent extends SchoolEvent {
  SchoolsDataEvent();
}

class SchoolDataEvent extends SchoolEvent {
  final String id;
  SchoolDataEvent(this.id);
}

class StudentsDataEvent extends SchoolEvent {
  final String schoolId;
  StudentsDataEvent(this.schoolId);
}

class StudentDataEvent extends SchoolEvent {
  final String studentId;
  final String schoolId;
  StudentDataEvent(this.studentId, this.schoolId);
}

class CreateOrUpdateSchoolEvent extends SchoolEvent {

  final SchoolModel school;
  final bool isCreateSchool;

  CreateOrUpdateSchoolEvent(this.school, {this.isCreateSchool = true});
}

class CreateOrEditStudentEvent extends SchoolEvent {

   final StudentModel student;

   final String schoolId;

   final bool isCreateStudent;

   CreateOrEditStudentEvent(this.student, this.schoolId, {this.isCreateStudent = true});
}

class CreateOrEditSchoolDetailsEvent extends SchoolEvent {

  final SchoolDetailsModel schoolDetails;

  CreateOrEditSchoolDetailsEvent(this.schoolDetails);
}

class DeleteSchoolEvent extends SchoolEvent {

  final String schoolId;

  DeleteSchoolEvent(this.schoolId);
}

class DeleteStudentEvent extends SchoolEvent {

  final String schoolId;

  final String studentId;

  DeleteStudentEvent( this.studentId, this.schoolId);
}

class SyncAndDumpTheData extends SchoolEvent {

  final bool isSyncData;

  SyncAndDumpTheData(this.isSyncData);
}