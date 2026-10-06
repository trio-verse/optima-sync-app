import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/channel/channel_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ChannelUsecases {
  final ChannelRepository repo;

  ChannelUsecases({required this.repo});

  Future<Either<WhateverFailure, List<ChannelEntity>>> getChannels() {
    return repo.getChannels();
  }

  Future<Either<WhateverFailure, ChannelEntity>> createChannel({
    required String name,
    required String color,
  }) {
    return repo.createChannel(name: name, color: color);
  }

  Future<Either<WhateverFailure, ChannelEntity>> updateChannel({
    required String id,
    required String name,
    required String color,
  }) {
    return repo.updateChannel(id: id, name: name, color: color);
  }

  Future<Either<WhateverFailure, void>> deleteChannel({required String id}) {
    return repo.deleteChannel(id: id);
  }
}
