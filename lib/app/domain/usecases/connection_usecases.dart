import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/connection_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/connection/connection_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ConnectionUsecases {
  final ConnectionRepository repo;

  ConnectionUsecases({required this.repo});

  Future<Either<WhateverFailure, List<ConnectionEntity>>> getClientConnections(
    String clientId,
  ) {
    return repo.getClientConnections(clientId);
  }

  Future<Either<WhateverFailure, List<ConnectionEntity>>> getAllConnections() {
    return repo.getAllConnections();
  }

  // Future<Either<WhateverFailure, ConnectionEntity>> getConnection(
  //   String connectionId,
  // ) {
  //   return repo.getConnection(connectionId);
  // }

  Future<Either<WhateverFailure, ConnectionEntity>> createConnection({
    required String clientId,
    required ConnectionEntity connection,
  }) {
    return repo.createConnection(clientId: clientId, connection: connection);
  }

  Future<Either<WhateverFailure, ConnectionEntity>> updateConnection({
    required String id,
    required ConnectionEntity connection,
  }) {
    return repo.updateConnection(id: id, connection: connection);
  }

  Future<Either<WhateverFailure, ConnectionEntity>> updateConnectionStage({
    required String id,
    required String stage,
    required ConnectionEntity current,
  }) {
    return repo.updateConnectionStage(id: id, stage: stage, current: current);
  }

  Future<Either<WhateverFailure, void>> deleteConnection(String id) {
    return repo.deleteConnection(id);
  }
}
