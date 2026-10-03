import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/local_data/auth_local_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/auth_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/repo/auth/auth_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<WhateverFailure, void>> signUp(String email) async {
    try {
      await remoteDataSource.signUp(email);
      return const Right(null);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, void>> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      final token = await remoteDataSource.verifyCode(email: email, code: code);
      await localDataSource.saveToken(token);
      return const Right(null);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<bool> isLogged() {
    return localDataSource.isLogged();
  }

  @override
  Future<void> logout() {
    return localDataSource.clearSession();
  }
}
