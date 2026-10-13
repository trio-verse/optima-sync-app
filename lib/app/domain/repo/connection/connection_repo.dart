import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/sales/connection_entity.dart';
import 'package:optima_sync_v2/core/errors/connection/connection_errors.dart';

abstract class ConnectionRepository {
  Future<Either<ConnectionError, List<ConnectionEntity>>> getClientConnections(
    String clientId,
  );

  Future<Either<ConnectionError, List<ConnectionEntity>>> getAllConnections();

  // Future<Either<ConnectionError, ConnectionEntity>> getConnection(
  //   String connectionId,
  // );

  Future<Either<ConnectionError, ConnectionEntity>> createConnection(
    ConnectionEntity connection,
  );
  Future<Either<ConnectionError, ConnectionEntity>> updateConnection(
    ConnectionEntity connection,
  );

  Future<Either<ConnectionError, void>> deleteConnection(String id);
}
