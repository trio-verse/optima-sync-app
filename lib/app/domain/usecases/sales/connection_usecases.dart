import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/sales/connection_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/connection/connection_repo.dart';
import 'package:optima_sync_v2/core/errors/connection/connection_errors.dart';

class ConnectionUsecases {
  final ConnectionRepository repo;

  ConnectionUsecases({required this.repo});

  Future<Either<ConnectionError, List<ConnectionEntity>>> getClientConnections(String clientId) {
    return repo.getClientConnections(clientId);
  }

  Future<Either<ConnectionError, List<ConnectionEntity>>> getAllConnections() {
    return repo.getAllConnections();
  }

  Future<Either<ConnectionError, ConnectionEntity>> createConnection(ConnectionEntity connection) {
    return repo.createConnection(connection);
  }

  Future<Either<ConnectionError, ConnectionEntity>> updateConnection(ConnectionEntity connection) {
    return repo.updateConnection(connection);
  }

  Future<Either<ConnectionError, void>> deleteConnection(String id) {
    return repo.deleteConnection(id);
  }
}
