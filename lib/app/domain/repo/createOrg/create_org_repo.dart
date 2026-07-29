import 'package:image_picker/image_picker.dart';

abstract class OrgRepository {
  Future<int> createOrg({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String description,
  });

  Future<void> uploadLogo({required int organizationId, required XFile image});
}
