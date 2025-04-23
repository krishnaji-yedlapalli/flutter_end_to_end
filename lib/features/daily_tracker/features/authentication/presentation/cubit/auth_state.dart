part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthStateLoaded extends AuthState {
  const AuthStateLoaded();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
