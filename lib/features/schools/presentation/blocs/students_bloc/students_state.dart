
import 'package:equatable/equatable.dart';

import '../../../../../core/data/utils/service_enums_typedef.dart';
import '../../../shared/models/student_view_model.dart';

abstract class StudentsState extends Equatable{
  const StudentsState();
}


class StudentsInfoInitial extends StudentsState {

  const StudentsInfoInitial();

  @override
  List<Object?> get props => [];

}

class StudentsInfoLoading extends StudentsState {

  const StudentsInfoLoading();

  @override
  List<Object?> get props => [];

}

class StudentInfoLoaded extends StudentsState {

  final StudentViewModel student;

  const StudentInfoLoaded(this.student);

  @override
  // TODO: implement props
  List<Object?> get props => [student];
}

class StudentsInfoLoaded extends StudentsState {

  final List<StudentViewModel> students;

  final String schoolId;

  const StudentsInfoLoaded(this.students, this.schoolId);

  @override
  // TODO: implement props
  List<Object?> get props => [students, schoolId];
}

class SchoolDataNotFound extends StudentsState {

  const SchoolDataNotFound();

  @override
  List<Object?> get props => [];

}

class SchoolDataError extends StudentsState {

  final ErrorDetails errorStateType;

  const SchoolDataError(this.errorStateType);

  @override
  List<Object?> get props => [errorStateType];

}
