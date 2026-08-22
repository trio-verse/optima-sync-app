import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';

abstract class ClientRepository {
  Future<ClientListResult> getClients(ClientFilter filter);

  Future<ClientEntity> createClient(ClientEntity client);

  Future<ClientEntity> updateClient({
    required String id,
    required ClientEntity client,
  });
}
