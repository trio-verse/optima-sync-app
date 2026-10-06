import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:optima_sync_v2/app/domain/entities/org_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class OrgRepository {
  Future<Either<WhateverFailure, List<OrgEntity>>> getOrganizations();

  Future<Either<WhateverFailure, String>> createOrg(OrgEntity org);

  Future<void> saveSelectedOrganization(String id);

  Future<Either<WhateverFailure, void>> uploadLogo({
    required String organizationId,
    required XFile image,
  });

  Future<Either<WhateverFailure, void>> selectOrganization({
    required String organizationId,
  });

  Future<bool> checkSelectedOrg();

  Future<String?> getSelectedOrganizationId();

  Future<Either<WhateverFailure, void>> updateOrg(OrgEntity org);
}
