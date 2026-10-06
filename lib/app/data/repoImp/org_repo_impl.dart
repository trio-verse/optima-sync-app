import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/org_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/org_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/createOrg/org_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class CreateOrgRepositoryImpl implements OrgRepository {
  final CreateOrgRemoteDataSource remoteDataSource;
  final OrgLocalDataSource localDataSource;

  CreateOrgRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<WhateverFailure, List<OrgEntity>>> getOrganizations() async {
    try {
      final res = await remoteDataSource.getOrganizations();
      return Right(res);
    } catch (e) {
      print(e);
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, String>> createOrg(OrgEntity org) async {
    try {
      final res = await remoteDataSource.createOrg(org);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, void>> uploadLogo({
    required String organizationId,
    required XFile image,
  }) async {
    try {
      final res = await remoteDataSource.uploadLogo(
        organizationId: organizationId,
        image: image,
      );
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, void>> selectOrganization({
    required String organizationId,
  }) async {
    try {
      final res = await remoteDataSource.selectOrganization(
        organizationId: organizationId,
      );
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<void> saveSelectedOrganization(String id) {
    return localDataSource.saveSelectedOrganization(id);
  }

  @override
  Future<bool> checkSelectedOrg() {
    return localDataSource.hasSelectedOrganization();
  }

  @override
  Future<String?> getSelectedOrganizationId() {
    return localDataSource.getSelectedOrganization();
  }

  @override
  Future<Either<WhateverFailure, void>> updateOrg(OrgEntity org) async {
    try {
      final res = await remoteDataSource.updateOrg(org);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }
}
