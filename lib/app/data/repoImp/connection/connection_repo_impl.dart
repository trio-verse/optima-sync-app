import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/connection_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/sales/connection_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/connection/connection_repo.dart';
import 'package:optima_sync_v2/core/errors/connection/connection_errors.dart';
import 'package:optima_sync_v2/core/errors/exceptions/exceptions.dart';

class ConnectionRepositoryImpl implements ConnectionRepository {
  final ConnectionRemoteDataSource remoteDataSource;

  ConnectionRepositoryImpl({required this.remoteDataSource});
  Future<Either<ConnectionError, T>> _guard<T>(
    Future<T> Function() call,
  ) async {
    try {
      return Right(await call());
    } on OfflineException {
      return const Left(ConnectionError.offline());
    } on UnauthorizedException {
      return const Left(ConnectionError.sessionExpired());
    } on NoOrganizationException {
      return const Left(ConnectionError.noOrganization());
    } on BadRequestException {
      return const Left(ConnectionError.invalidData());
    } on NotFoundException {
      return const Left(ConnectionError.notFound());
    } catch (e) {
      return const Left(ConnectionError.serverError());
    }
  }

  @override
  Future<Either<ConnectionError, List<ConnectionEntity>>> getClientConnections(
    String clientId,
  ) => _guard(() => remoteDataSource.getClientConnections(clientId));

  @override
  Future<Either<ConnectionError, List<ConnectionEntity>>> getAllConnections() =>
      _guard(() => remoteDataSource.getAllConnections());

  @override
  Future<Either<ConnectionError, ConnectionEntity>> createConnection(
    ConnectionEntity connection,
  ) => _guard(() => remoteDataSource.createConnection(connection));

  @override
  Future<Either<ConnectionError, ConnectionEntity>> updateConnection(
    ConnectionEntity connection,
  ) => _guard(() => remoteDataSource.updateConnection(connection));

  @override
  Future<Either<ConnectionError, void>> deleteConnection(String id) =>
      _guard<void>(() => remoteDataSource.deleteConnection(id));
}
