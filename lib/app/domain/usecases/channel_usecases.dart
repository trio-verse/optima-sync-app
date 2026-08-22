import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/channel/channel_repo.dart';

class ChannelUsecases {
  final ChannelRepository repo;

  ChannelUsecases({required this.repo});

  Future<List<ChannelEntity>> getChannels() {
    return repo.getChannels();
  }

  Future<ChannelEntity> createChannel({
    required String name,
    required String color,
  }) {
    return repo.createChannel(name: name, color: color);
  }

  Future<ChannelEntity> updateChannel({
    required String id,
    required String name,
    required String color,
  }) {
    return repo.updateChannel(id: id, name: name, color: color);
  }

  Future<void> deleteChannel({required String id}) {
    return repo.deleteChannel(id: id);
  }
}
