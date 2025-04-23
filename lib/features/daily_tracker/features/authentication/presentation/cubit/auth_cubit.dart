import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sample_latest/features/daily_tracker/domain/usecases/auth_use_case.dart';

import '../../../../../../core/mixins/notifiers.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthUseCase _authUseCase;

  AuthCubit(this._authUseCase) : super(AuthStateLoading());

  Future<bool> validateUserCredentials(String email, String pwd) async {
    var status = false;
    var completer = Completer();

    var res = await _authUseCase.call(email, pwd);
    res.fold((loginStatus) {
      status = loginStatus;
      completer.complete();
    }, (error) {
      Notifiers.toastNotifier('Invalid Credentials');
    });
    await completer.future;
    return status;
  }
}
