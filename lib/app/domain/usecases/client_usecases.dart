import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/client/client_repo.dart';

class ClientUsecases {
  final ClientRepository repo;

  ClientUsecases({required this.repo});

  Future<ClientListResult> getClients(ClientFilter filter) {
    return repo.getClients(filter);
  }

  Future<ClientEntity> createClient(ClientEntity client) {
    return repo.createClient(client);
  }

  Future<ClientEntity> updateClient({
    required String id,
    required ClientEntity client,
  }) {
    return repo.updateClient(id: id, client: client);
  }
}
