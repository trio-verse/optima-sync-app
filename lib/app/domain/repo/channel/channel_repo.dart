import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class ChannelRepository {
  Future<Either<WhateverFailure, List<ChannelEntity>>> getChannels();

  Future<Either<WhateverFailure, ChannelEntity>> createChannel({
    required String name,
    required String color,
  });

  Future<Either<WhateverFailure, ChannelEntity>> updateChannel({
    required String id,
    required String name,
    required String color,
  });

  Future<Either<WhateverFailure, void>> deleteChannel({required String id});
}
