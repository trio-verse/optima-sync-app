import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/client/client_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ClientUsecases {
  final ClientRepository repo;

  ClientUsecases({required this.repo});

  Future<Either<WhateverFailure, ClientListResult>> getClients(
    ClientFilter filter,
  ) {
    return repo.getClients(filter);
  }

  Future<Either<WhateverFailure, ClientEntity>> createClient(
    ClientEntity client,
  ) {
    return repo.createClient(client);
  }

  Future<Either<WhateverFailure, ClientEntity>> updateClient({
    required String id,
    required ClientEntity client,
  }) {
    return repo.updateClient(id: id, client: client);
  }
}
