import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckLoginStatus extends AuthEvent {}

class SignUpSubmitted extends AuthEvent {
  final String email;

  const SignUpSubmitted({required this.email});

  @override
  List<Object> get props => [email];
}

class VerifyCodeSubmitted extends AuthEvent {
  final String email;
  final String code;

  const VerifyCodeSubmitted({required this.email, required this.code});

  @override
  List<Object> get props => [email, code];
}
