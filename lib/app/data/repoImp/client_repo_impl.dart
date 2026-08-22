import 'package:optima_sync_v2/app/data/sources/remote_data/client_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/client/client_repo.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDataSource remoteDataSource;

  ClientRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ClientListResult> getClients(ClientFilter filter) {
    return remoteDataSource.getClients(filter);
  }

  @override
  Future<ClientEntity> createClient(ClientEntity client) {
    return remoteDataSource.createClient(client);
  }

  @override
  Future<ClientEntity> updateClient({
    required String id,
    required ClientEntity client,
  }) {
    return remoteDataSource.updateClient(id: id, client_: client);
  }
}
