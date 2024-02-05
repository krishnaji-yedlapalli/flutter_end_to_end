part of 'school_bloc.dart';


@immutable
abstract class SchoolEvent {

}

class SchoolsDataEvent extends SchoolEvent {
  SchoolsDataEvent();
}

class SchoolDataEvent extends SchoolEvent {
  SchoolDataEvent();
}

class StudentDataEvent extends SchoolEvent {
  StudentDataEvent();

}