import 'package:optima_sync_v2/app/domain/repo/auth/auth_repo.dart';

class VerifyCodeUseCase {
  final AuthRepository repository;

  VerifyCodeUseCase(this.repository);

  Future<void> execute({required String email, required String code}) async {
    await repository.verifyCode(email: email, code: code);
  }
}
