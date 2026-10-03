import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/channel_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/channel/channel_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ChannelRepositoryImpl implements ChannelRepository {
  final ChannelRemoteDataSource remoteDataSource;

  ChannelRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, List<ChannelEntity>>> getChannels() async {
    try {
      final res = await remoteDataSource.getChannels();
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ChannelEntity>> createChannel({
    required String name,
    required String color,
  }) async {
    try {
      final res = await remoteDataSource.createChannel(name: name, color: color);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ChannelEntity>> updateChannel({
    required String id,
    required String name,
    required String color,
  }) async {
    try {
      final res = await remoteDataSource.updateChannel(
        id: id,
        name: name,
        color: color,
      );
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, void>> deleteChannel({
    required String id,
  }) async {
    try {
      final res = await remoteDataSource.deleteChannel(id: id);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }
}
