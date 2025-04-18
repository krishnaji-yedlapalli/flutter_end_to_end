import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/profile_entity.dart';

import '../../../../domain/usecases/users_useCase.dart';

part 'profiles_cubit_state.dart';

class ProfilesCubit extends Cubit<ProfilesState> {
  ProfilesCubit(this._useCase) : super(const ProfilesStateInitial());

  final ProfilesUseCase _useCase;

  Future<void> loadExistingProfiles() async {
    emit(ProfilesStateLoading());

    var profiles = await _useCase.call();

    emit(ProfilesStateLoaded(profiles));
  }

  void onSelectionOfProfile(String id) {
    if (state is ProfilesStateLoaded) {
      final loadedState = state as ProfilesStateLoaded;
      for (var p in loadedState.profiles) {
        p.isSelected = false;
      }
      final profile = loadedState.profiles.firstWhere((p) => p.id == id);
        profile.isSelected = true;
        emit(ProfilesStateLoaded(loadedState.profiles, selectedProfile : profile));
    }
  }

  Future<void> createUser(ProfileEntity profile) async {
  }
}
