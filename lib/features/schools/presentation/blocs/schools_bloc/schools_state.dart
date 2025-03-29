
import 'package:equatable/equatable.dart';

import '../../../../../core/data/utils/service_enums_typedef.dart';
import '../../../shared/models/school_view_model.dart';

abstract class SchoolsState extends Equatable{

  final bool isWelcomeMessageShowed;

  const SchoolsState({this.isWelcomeMessageShowed = true});
}

class SchoolsInfoInitial extends SchoolsState {

  const SchoolsInfoInitial();

  @override
  List<Object?> get props => [];

}

class SchoolsInfoLoading extends SchoolsState {

  const SchoolsInfoLoading({bool showedWelcomeMessage = true}) : super(isWelcomeMessageShowed: showedWelcomeMessage);

  @override
  List<Object?> get props => [];

}

class SchoolsInfoLoaded extends SchoolsState {

  final List<SchoolViewModel> schools;

  const SchoolsInfoLoaded(this.schools);

  @override
  List<Object?> get props => [schools];
}

class SchoolDataError extends SchoolsState {

  final ErrorDetails errorStateType;

  const SchoolDataError(this.errorStateType);

  @override
  List<Object?> get props => [errorStateType];

}