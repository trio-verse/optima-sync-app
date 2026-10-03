import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/connection_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/connection_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/connection/connection_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ConnectionRepositoryImpl implements ConnectionRepository {
  final ConnectionRemoteDataSource remoteDataSource;

  ConnectionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, List<ConnectionEntity>>> getClientConnections(
    String clientId,
  ) async {
    try {
      final res = await remoteDataSource.getClientConnections(clientId);
      print("===============");
      print(res);
      print("================");
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, List<ConnectionEntity>>>
  getAllConnections() async {
    try {
      final res = await remoteDataSource.getAllConnections();
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  // @override
  // Future<Either<WhateverFailure, ConnectionEntity>> getConnection(
  //   String connectionId,
  // ) async {
  //   try {
  //     final res = await remoteDataSource.getConnection(connectionId);
  //     return Right(res);
  //   } catch (e) {
  //     return Left(WhateverFailure.whatoffline());
  //   }
  // }

  @override
  Future<Either<WhateverFailure, ConnectionEntity>> createConnection({
    required String clientId,
    required ConnectionEntity connection,
  }) async {
    try {
      final res = await remoteDataSource.createConnection(
        clientId: clientId,
        connection: connection,
      );
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ConnectionEntity>> updateConnection({
    required String id,
    required ConnectionEntity connection,
  }) async {
    try {
      final res = await remoteDataSource.updateConnection(
        id: id,
        connection: connection,
      );
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ConnectionEntity>> updateConnectionStage({
    required String id,
    required String stage,
    required ConnectionEntity current,
  }) async {
    try {
      final res = await remoteDataSource.updateConnectionStage(
        id: id,
        stage: stage,
        current: current,
      );
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, void>> deleteConnection(String id) async {
    try {
      final res = await remoteDataSource.deleteConnection(id);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }
}
