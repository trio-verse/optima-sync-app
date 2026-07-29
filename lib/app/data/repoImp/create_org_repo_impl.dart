import 'package:image_picker/image_picker.dart';
import 'package:optima_sync_v2/app/data/sources/local_data/auth_local_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/create_org_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/repo/createOrg/create_org_repo.dart';

class CreateOrgRepositoryImpl implements OrgRepository {
  final CreateOrgRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  CreateOrgRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<int> createOrg({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String description,
  }) async {
    final token = await localDataSource.getToken();

    return await remoteDataSource.createOrg(
      token: token!,
      name: name,
      email: email,
      phone: phone,
      address: address,
      description: description,
    );
  }

  @override
  Future<void> uploadLogo({
    required int organizationId,
    required XFile image,
  }) async {
    final token = await localDataSource.getToken();

    await remoteDataSource.uploadLogo(
      token: token!,
      organizationId: organizationId,
      image: image,
    );
  }
}
