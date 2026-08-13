import 'package:image_picker/image_picker.dart';
import 'package:optima_sync_v2/app/domain/entities/org_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/createOrg/org_repo.dart';

class OrgUsecases {
  final OrgRepository repo;

  OrgUsecases({required this.repo});

  Future<String> createOrg(OrgEntity org) {
    return repo.createOrg(org);
  }

  Future<void> selectOrganization({required String organizationId}) {
    return repo.selectOrganization(organizationId: organizationId);
  }

  Future<void> saveSelectedOrganization(String id) {
    return repo.saveSelectedOrganization(id);
  }

  Future<void> uploadLogo({
    required String organizationId,
    required XFile image,
  }) {
    return repo.uploadLogo(organizationId: organizationId, image: image);
  }

  Future<bool> CheckSelectedOrg() async {
    return repo.CheckSelectedOrg();
  }

  Future<String?> getSelectedOrganizationId() {
    return repo.getSelectedOrganizationId();
  }

  Future<List<OrgEntity>> getOrganizations() {
    return repo.getOrganizations();
  }

  Future<void> updateOrg(OrgEntity org) {
    return repo.updateOrg(org);
  }
}
