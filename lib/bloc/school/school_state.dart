part of 'school_bloc.dart';

enum SchoolDataLoadedType {schools, school, students, student}

abstract class SchoolState extends Equatable{

  final SchoolDataLoadedType schoolStateType;

  const SchoolState(this.schoolStateType);
}


class SchoolInfoInitial extends SchoolState {

  SchoolInfoInitial(super.schoolStateType);

  @override
  List<Object?> get props => [];

}

class SchoolInfoLoading extends SchoolState {

  SchoolInfoLoading(super.schoolStateType);

  @override
  List<Object?> get props => [];

}

class SchoolsInfoLoaded extends SchoolState {

   final List<SchoolModel> schools;

   const SchoolsInfoLoaded(SchoolDataLoadedType schoolStateType, this.schools) : super(schoolStateType);

  @override
  List<Object?> get props => [super.schoolStateType, schools];
}

class SchoolInfoLoaded extends SchoolState {

  final SchoolDetailsModel school;

  SchoolInfoLoaded(super.schoolStateType, this.school);

  @override
  // TODO: implement props
  List<Object?> get props => [super.schoolStateType, school];
}

class StudentInfoLoaded extends SchoolState {

  final StudentModel student;

  final int schoolId;

  StudentInfoLoaded(super.schoolStateType, this.student, this.schoolId);

  @override
  // TODO: implement props
  List<Object?> get props => [super.schoolStateType, student, schoolId];
}

class StudentsInfoLoaded extends SchoolState {

  final List<StudentModel> students;

  final int schoolId;

  // final SchoolDetailsModel? school;

  StudentsInfoLoaded(super.schoolStateType, this.students, this.schoolId);

  @override
  // TODO: implement props
  List<Object?> get props => [super.schoolStateType, students, schoolId];
}

class SchoolDataNotFound extends SchoolState {

  const SchoolDataNotFound(super.schoolStateType);

  @override
  List<Object?> get props => [super.schoolStateType];

}

class DataError extends SchoolState {

  DataError(super.schoolStateType);

  @override
  List<Object?> get props => [];

}




