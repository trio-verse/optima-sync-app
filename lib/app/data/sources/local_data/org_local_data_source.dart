import 'package:shared_preferences/shared_preferences.dart';

class OrgLocalDataSource {
  final SharedPreferences storage;

  OrgLocalDataSource({required this.storage});

  Future<void> saveSelectedOrganization(String id) async {
    await storage.setString('selectedOrganizationId', id);
  }

  Future<String?> getSelectedOrganization() async {
    return storage.getString('selectedOrganizationId');
  }

  Future<bool> hasSelectedOrganization() async {
    return storage.containsKey('selectedOrganizationId');
  }
}
