abstract class AuthRepository {
  Future<void> signUp(String email);

  Future<void> verifyCode({required String email, required String code});

  Future<bool> isLogged();
}
