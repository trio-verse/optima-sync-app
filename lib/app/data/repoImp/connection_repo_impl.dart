import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/connection_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/sales/connection_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/connection/connection_repo.dart';
import 'package:optima_sync_v2/core/errors/connection/connection_errors.dart';

class ConnectionRepositoryImpl implements ConnectionRepository {
  final ConnectionRemoteDataSource remoteDataSource;

  ConnectionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ConnectionError, List<ConnectionEntity>>> getClientConnections(
    String clientId,
  ) async {
    try {
      final res = await remoteDataSource.getClientConnections(clientId);
      print("===============");
      print(res);
      print("================");
      return Right(res);
    } catch (e) {
      return Left(ConnectionError.connectionOffline());
    }
  }

  @override
  Future<Either<ConnectionError, List<ConnectionEntity>>>
  getAllConnections() async {
    try {
      final res = await remoteDataSource.getAllConnections();
      return Right(res);
    } catch (e) {
      return Left(ConnectionError.connectionOffline());
    }
  }

  // @override
  // Future<Either<ConnectionError, ConnectionEntity>> getConnection(
  //   String connectionId,
  // ) async {
  //   try {
  //     final res = await remoteDataSource.getConnection(connectionId);
  //     return Right(res);
  //   } catch (e) {
  //     return Left(ConnectionError.whatoffline());
  //   }
  // }

  @override
  Future<Either<ConnectionError, ConnectionEntity>> createConnection(
    ConnectionEntity connection,
  ) async {
    try {
      final res = await remoteDataSource.createConnection(connection);
      return Right(res);
    } catch (e) {
      return Left(ConnectionError.connectionOffline());
    }
  }

  @override
  Future<Either<ConnectionError, ConnectionEntity>> updateConnection(
    ConnectionEntity connection,
  ) async {
    try {
      final res = await remoteDataSource.updateConnection(connection);
      return Right(res);
    } catch (e) {
      return Left(ConnectionError.connectionOffline());
    }
  }

  @override
  Future<Either<ConnectionError, void>> deleteConnection(String id) async {
    try {
      final res = await remoteDataSource.deleteConnection(id);
      return Right(res);
    } catch (e) {
      return Left(ConnectionError.connectionOffline());
    }
  }
}
