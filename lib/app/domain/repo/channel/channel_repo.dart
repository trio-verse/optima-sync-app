import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';

abstract class ChannelRepository {
  Future<List<ChannelEntity>> getChannels();

  Future<ChannelEntity> createChannel({
    required String name,
    required String color,
  });
  Future<ChannelEntity> updateChannel({
    required String id,
    required String name,
    required String color,
  });

  Future<void> deleteChannel({required String id});
}
