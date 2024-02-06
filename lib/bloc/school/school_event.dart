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