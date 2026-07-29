import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final SharedPreferences storage;

  AuthLocalDataSource({required this.storage});

  Future<bool> isLogged() async {
    return storage.containsKey('Token');
  }

  Future<void> saveToken(String token) async {
    await storage.setString('Token', token);
  }

  Future<String?> getToken() async {
    return storage.getString('Token');
  }
}
