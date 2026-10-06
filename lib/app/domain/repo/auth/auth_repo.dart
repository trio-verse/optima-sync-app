import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<WhateverFailure, void>> signUp(String email);

  Future<Either<WhateverFailure, void>> verifyCode({
    required String email,
    required String code,
  });

  Future<bool> isLogged();

  Future<void> logout();
}
