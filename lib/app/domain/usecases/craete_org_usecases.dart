import 'package:optima_sync_v2/app/domain/repo/createOrg/create_org_repo.dart';
import 'package:cross_file/cross_file.dart';

class OrgUsecases {
  final OrgRepository repo;

  OrgUsecases({required this.repo});

  Future<int> createOrg({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String description,
  }) async {
    return await repo.createOrg(
      name: name,
      email: email,
      phone: phone,
      address: address,
      description: description,
    );
  }

  Future<void> uploadLogo({
    required int organizationId,
    required XFile image,
  }) async {
    await repo.uploadLogo(organizationId: organizationId, image: image);
  }
}
