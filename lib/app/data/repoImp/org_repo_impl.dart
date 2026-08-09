import 'package:image_picker/image_picker.dart';
import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/org_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/org_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/createOrg/org_repo.dart';

class CreateOrgRepositoryImpl implements OrgRepository {
  final CreateOrgRemoteDataSource remoteDataSource;
  final OrgLocalDataSource localDataSource;
  CreateOrgRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<OrgEntity>> getOrganizations() {
    return remoteDataSource.getOrganizations();
  }

  @override
  Future<String> createOrg(OrgEntity org) {
    return remoteDataSource.createOrg(org);
  }

  @override
  Future<void> uploadLogo({
    required String organizationId,
    required XFile image,
  }) {
    return remoteDataSource.uploadLogo(
      organizationId: organizationId,
      image: image,
    );
  }

  @override
  Future<void> selectOrganization({required String organizationId}) {
    return remoteDataSource.selectOrganization(organizationId: organizationId);
  }

  @override
  Future<void> saveSelectedOrganization(String id) {
    return localDataSource.saveSelectedOrganization(id);
  }

  @override
  Future<bool> CheckSelectedOrg() {
    return localDataSource.hasSelectedOrganization();
  }

  @override
  Future<String?> getSelectedOrganizationId() {
    return localDataSource.getSelectedOrganization();
  }
}
