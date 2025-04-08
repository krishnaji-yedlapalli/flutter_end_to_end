part of 'users_cubit.dart';

abstract class UsersState {
  const UsersState();
}

class UsersStateInitial extends UsersState {
  const UsersStateInitial();
}

class UsersStateLoading extends UsersState {
  UsersStateLoading();
}

class UsersStateLoaded extends UsersState {
  final List<UserEntity> users;

  UsersStateLoaded(this.users);
}

class UsersStateFailed extends UsersState {
  const UsersStateFailed();
}
