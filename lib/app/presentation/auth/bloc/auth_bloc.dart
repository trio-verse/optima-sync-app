import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUsecases usecases;
  AuthBloc({required this.usecases}) : super(AuthInitial()) {
    on<CheckLoginStatus>((event, emit) async {
      print(' AuthBloc: SignUpSubmitted received');

      emit(AuthLoading());
      try {
        print(' Calling usecases.signup...');
        final isLoggedIn = await usecases.isLogged();
        if (isLoggedIn) {
          emit(LoggedIn());
        } else {
          emit(LoggedOut());
        }
      } catch (e) {
        print(' AuthBloc Error: $e');
        emit(AuthFailure(message: e.toString()));
      }
    });
    on<SignUpSubmitted>(_onSignUp);

    on<VerifyCodeSubmitted>(_onVerifyCode);
  }

  Future<void> _onSignUp(SignUpSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await usecases.signup(event.email);

      emit(SignUpSuccess(email: event.email));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onVerifyCode(
    VerifyCodeSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await usecases.verifyOtp(email: event.email, code: event.code);

      emit(VerifySuccess());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
