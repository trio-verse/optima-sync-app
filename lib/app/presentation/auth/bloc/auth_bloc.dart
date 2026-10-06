import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/usecases/auth_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUsecases usecases;

  AuthBloc({required this.usecases}) : super(AuthInitial()) {
    on<CheckLoginStatus>((event, emit) async {
      emit(AuthLoading());

      try {
        final isLoggedIn = await usecases.isLogged();
        emit(isLoggedIn ? LoggedIn() : LoggedOut());
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    on<SignUpSubmitted>(_onSignUp);
    on<VerifyCodeSubmitted>(_onVerifyCode);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(LogoutInProgress());

    try {
      await usecases.logout();
      emit(LoggedOut());
    } catch (e) {
      emit(AuthFailure(message: 'Unable to log out, please try again'));
    }
  }

  Future<void> _onSignUp(SignUpSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await usecases.signup(event.email);

    result.fold(
      (failure) => emit(AuthFailure(message: _messageFor(failure))),
      (_) => emit(SignUpSuccess(email: event.email)),
    );
  }

  Future<void> _onVerifyCode(
    VerifyCodeSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await usecases.verifyOtp(email: event.email, code: event.code);

    result.fold(
      (failure) => emit(AuthFailure(message: _messageFor(failure))),
      (_) => emit(VerifySuccess()),
    );
  }

  String _messageFor(WhateverFailure failure) {
    return failure.when(
      serverError: () => 'Server error, please try again',
      whatoffline: () => 'No internet connection',
      database: () => 'Something went wrong, please try again',
    );
  }
}
