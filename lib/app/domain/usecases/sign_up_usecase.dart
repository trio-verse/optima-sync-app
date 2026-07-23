import 'package:optima_sync_v2/app/domain/repo/auth/auth_repo.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<void> execute(String email) async {
    await repository.signUp(email);
  }
}
