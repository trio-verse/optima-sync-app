import 'package:image_picker/image_picker.dart';
import 'package:optima_sync_v2/app/domain/entities/org_entity.dart';

abstract class OrgRepository {
  Future<List<OrgEntity>> getOrganizations();

  Future<String> createOrg(OrgEntity org);

  Future<void> saveSelectedOrganization(String id);

  Future<void> uploadLogo({
    required String organizationId,
    required XFile image,
  });

  Future<void> selectOrganization({required String organizationId});

  Future<bool> checkSelectedOrg();

  Future<String?> getSelectedOrganizationId();
  Future<void> updateOrg(OrgEntity org);
}
