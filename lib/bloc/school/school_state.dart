part of 'school_bloc.dart';

enum SchoolDataLoadedType {schools, school, students, student}

abstract class SchoolState extends Equatable{

  final SchoolDataLoadedType schoolStateType;

  final bool isWelcomeMessageShowed;

  const SchoolState(this.schoolStateType, {this.isWelcomeMessageShowed = true});
}


class SchoolInfoInitial extends SchoolState {

  const SchoolInfoInitial(super.schoolStateType);

  @override
  List<Object?> get props => [];

}

class SchoolInfoLoading extends SchoolState {

  const SchoolInfoLoading(super.schoolStateType, {bool showedWelcomeMessage = true}) : super(isWelcomeMessageShowed: showedWelcomeMessage);

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

  const SchoolInfoLoaded(super.schoolStateType, this.school);

  @override
  // TODO: implement props
  List<Object?> get props => [super.schoolStateType, school];
}

class StudentInfoLoaded extends SchoolState {

  final StudentModel student;

  final String schoolId;

  const StudentInfoLoaded(super.schoolStateType, this.student, this.schoolId);

  @override
  // TODO: implement props
  List<Object?> get props => [super.schoolStateType, student, schoolId];
}

class StudentsInfoLoaded extends SchoolState {

  final List<StudentModel> students;

  final String schoolId;

  // final SchoolDetailsModel? school;

  const StudentsInfoLoaded(super.schoolStateType, this.students, this.schoolId);

  @override
  // TODO: implement props
  List<Object?> get props => [super.schoolStateType, students, schoolId];
}

class SchoolDataNotFound extends SchoolState {

  const SchoolDataNotFound(super.schoolStateType);

  @override
  List<Object?> get props => [super.schoolStateType];

}

class SchoolDataError extends SchoolState {

  final ErrorDetails errorStateType;

  const SchoolDataError(super.schoolStateType, this.errorStateType);

  @override
  List<Object?> get props => [schoolStateType, errorStateType];

}




