import 'package:equatable/equatable.dart';
import 'package:sample_latest/features/schools/shared/models/school_details_view_model.dart';

import '../../../../../core/data/utils/service_enums_typedef.dart';

abstract class SchoolDetailsState extends Equatable {
  final bool viewAllStudents;
  const SchoolDetailsState({this.viewAllStudents = false});
}

class SchoolDetailsInitial extends SchoolDetailsState {
  const SchoolDetailsInitial();

  @override
  List<Object?> get props => [];
}

class SchoolDetailsInitialLoading extends SchoolDetailsState {
  const SchoolDetailsInitialLoading();

  @override
  List<Object?> get props => [];
}

class SchoolDetailsInfoLoaded extends SchoolDetailsState {
  final SchoolDetailsViewModel schoolDetails;

  const SchoolDetailsInfoLoaded(this.schoolDetails,
      {bool viewAllStudents = false})
      : super(viewAllStudents: viewAllStudents);

  SchoolDetailsInfoLoaded copyWith(
      {SchoolDetailsViewModel? schoolDetails, bool? viewAllStudents}) {
    return SchoolDetailsInfoLoaded(schoolDetails ?? this.schoolDetails,
        viewAllStudents: viewAllStudents ?? super.viewAllStudents);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [SchoolDetailsViewModel, viewAllStudents];
}

class SchoolDetailsDataNotFound extends SchoolDetailsState {
  const SchoolDetailsDataNotFound();

  @override
  List<Object?> get props => [];
}

class SchoolDetailsDataError extends SchoolDetailsState {
  final ErrorDetails errorStateType;

  const SchoolDetailsDataError(this.errorStateType);

  @override
  List<Object?> get props => [errorStateType];
}
