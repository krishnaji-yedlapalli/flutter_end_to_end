part of 'schools_cubit.dart';

sealed class SchoolsState extends Equatable {
  final bool isWelcomeMessageShown;

  const SchoolsState({this.isWelcomeMessageShown = true});

  @override
  List<Object?> get props => [isWelcomeMessageShown];
}

class SchoolsInfoInitial extends SchoolsState {
  const SchoolsInfoInitial({bool isWelcomeMessageShown = true})
      : super(isWelcomeMessageShown: isWelcomeMessageShown);
}

class SchoolsInfoLoading extends SchoolsState {
  const SchoolsInfoLoading({bool isWelcomeMessageShown = true})
      : super(isWelcomeMessageShown: isWelcomeMessageShown);
}

class SchoolsInfoLoaded extends SchoolsState {
  final SchoolsUiModel schoolsUiModel;

  const SchoolsInfoLoaded(
    this.schoolsUiModel, {
    bool isWelcomeMessageShown = true,
  }) : super(isWelcomeMessageShown: isWelcomeMessageShown);

  @override
  List<Object?> get props => [schoolsUiModel.schools, isWelcomeMessageShown];
}

class SchoolDataError extends SchoolsState {
  final ErrorDetails errorStateType;

  const SchoolDataError(
    this.errorStateType, {
    bool isWelcomeMessageShown = true,
  }) : super(isWelcomeMessageShown: isWelcomeMessageShown);

  @override
  List<Object?> get props => [errorStateType, isWelcomeMessageShown];
}
