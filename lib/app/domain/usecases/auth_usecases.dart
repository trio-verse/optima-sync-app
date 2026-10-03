import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/repo/auth/auth_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class AuthUsecases {
  final AuthRepository repo;

  AuthUsecases({required this.repo});

  Future<Either<WhateverFailure, void>> signup(String email) {
    return repo.signUp(email);
  }

  Future<Either<WhateverFailure, void>> verifyOtp({
    required String email,
    required String code,
  }) {
    return repo.verifyCode(email: email, code: code);
  }

  Future<bool> isLogged() {
    return repo.isLogged();
  }

  Future<void> logout() {
    return repo.logout();
  }
}
