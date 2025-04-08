import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/user_entity.dart';
import 'package:sample_latest/features/daily_tracker/domain/usecases/users_useCase.dart';

part 'users_cubit_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit(super.initialState, this._useCase);

  final UsersUseCase _useCase;

  Future<void> loadExistingUsers() async {
    emit(UsersStateLoading());

    var users = await _useCase.call();

    emit(UsersStateLoaded(users));
  }
}
