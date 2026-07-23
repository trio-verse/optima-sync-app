import 'package:optima_sync_v2/app/domain/repo/auth/auth_repo.dart';

class AuthUsecases {
  final AuthRepository repo;

  AuthUsecases({required this.repo});
  Future<void> signup(String email) async {
    await repo.signUp(email);
  }

  Future<void> verifyOtp({required String email, required String code}) async {
    await repo.verifyCode(email: email, code: code);
  }

  Future<bool> isLogged() async {
    return await repo.isLogged();
  }
}
