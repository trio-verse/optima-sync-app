import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class ClientRepository {
  Future<Either<WhateverFailure, ClientListResult>> getClients(
    ClientFilter filter,
  );

  Future<Either<WhateverFailure, ClientEntity>> createClient(
    ClientEntity client,
  );

  Future<Either<WhateverFailure, ClientEntity>> updateClient({
    required String id,
    required ClientEntity client,
  });
}
