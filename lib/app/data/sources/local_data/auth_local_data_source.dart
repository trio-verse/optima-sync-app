import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final SharedPreferences storage;

  AuthLocalDataSource({required this.storage});

  Future<bool> isLogged() async {
    final token = storage.getString('Token');
    return token != null && token.trim().isNotEmpty;
  }

  Future<void> saveToken(String token) async {
    await storage.setString('Token', token);
  }

  Future<void> clearSession() async {
    await storage.remove('Token');
    await storage.remove('selectedOrganizationId');
  }
}
