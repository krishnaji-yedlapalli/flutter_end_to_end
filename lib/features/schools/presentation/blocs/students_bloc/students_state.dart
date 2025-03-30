
import 'package:equatable/equatable.dart';

import '../../../../../core/data/utils/service_enums_typedef.dart';
import '../../../shared/models/student_view_model.dart';

enum StudentStateType {student, students}

abstract class StudentsState extends Equatable{

  final StudentStateType stateType;
  const StudentsState({this.stateType = StudentStateType.students});
}


class StudentsInfoInitial extends StudentsState {

  const StudentsInfoInitial({super.stateType});

  @override
  List<Object?> get props => [];

}

class StudentsInfoLoading extends StudentsState {

  const StudentsInfoLoading({super.stateType});

  @override
  List<Object?> get props => [];

}

class StudentInfoLoaded extends StudentsState {

  final StudentViewModel student;

  const StudentInfoLoaded(this.student, {super.stateType});

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

  const SchoolDataNotFound({super.stateType});

  @override
  List<Object?> get props => [];

}

class SchoolDataError extends StudentsState {

  final ErrorDetails errorStateType;

  const SchoolDataError(this.errorStateType, {super.stateType});

  @override
  List<Object?> get props => [errorStateType];

}
