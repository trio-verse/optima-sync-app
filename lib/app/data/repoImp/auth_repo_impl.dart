import 'package:optima_sync_v2/app/data/sources/local_data/auth_local_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/auth_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/repo/auth/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> signUp(String email) async {
    await remoteDataSource.signUp(email);
  }

  @override
  Future<void> verifyCode({required String email, required String code}) async {
    print('Repo Function Started!');
    await remoteDataSource.verifyCode(email: email, code: code);

    // Store the token returned from otp varefication
  }

  @override
  Future<bool> isLogged() async {
    return localDataSource.isLogged();
  }
}
