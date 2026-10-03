import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/client_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/client/client_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDataSource remoteDataSource;

  ClientRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, ClientListResult>> getClients(
    ClientFilter filter,
  ) async {
    try {
      final res = await remoteDataSource.getClients(filter);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ClientEntity>> createClient(
    ClientEntity client,
  ) async {
    try {
      final res = await remoteDataSource.createClient(client);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ClientEntity>> updateClient({
    required String id,
    required ClientEntity client,
  }) async {
    try {
      final res = await remoteDataSource.updateClient(id: id, client_: client);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }
}
