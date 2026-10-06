import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:optima_sync_v2/app/domain/entities/org_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/createOrg/org_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class OrgUsecases {
  final OrgRepository repo;

  OrgUsecases({required this.repo});

  Future<Either<WhateverFailure, String>> createOrg(OrgEntity org) {
    return repo.createOrg(org);
  }

  Future<Either<WhateverFailure, void>> selectOrganization({
    required String organizationId,
  }) {
    return repo.selectOrganization(organizationId: organizationId);
  }

  Future<void> saveSelectedOrganization(String id) {
    return repo.saveSelectedOrganization(id);
  }

  Future<Either<WhateverFailure, void>> uploadLogo({
    required String organizationId,
    required XFile image,
  }) {
    return repo.uploadLogo(organizationId: organizationId, image: image);
  }

  Future<bool> checkSelectedOrg() {
    return repo.checkSelectedOrg();
  }

  Future<String?> getSelectedOrganizationId() {
    return repo.getSelectedOrganizationId();
  }

  Future<Either<WhateverFailure, List<OrgEntity>>> getOrganizations() {
    return repo.getOrganizations();
  }

  Future<Either<WhateverFailure, void>> updateOrg(OrgEntity org) {
    return repo.updateOrg(org);
  }
}
