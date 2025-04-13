part of 'profiles_cubit.dart';

sealed class ProfilesState {
  const ProfilesState();
}

class ProfilesStateInitial extends ProfilesState {
  const ProfilesStateInitial();
}

class ProfilesStateLoading extends ProfilesState {
  ProfilesStateLoading();
}

class ProfilesStateLoaded extends ProfilesState {
  final List<ProfileEntity> profiles;
  final ProfileEntity? selectedProfile;

  ProfilesStateLoaded(this.profiles, {this.selectedProfile});
}

class ProfilesStateFailed extends ProfilesState {
  const ProfilesStateFailed();
}
