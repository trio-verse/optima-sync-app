import 'package:optima_sync_v2/app/data/sources/remote_data/channel_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/channel/channel_repo.dart';

class ChannelRepositoryImpl implements ChannelRepository {
  final ChannelRemoteDataSource remoteDataSource;

  ChannelRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ChannelEntity>> getChannels() {
    return remoteDataSource.getChannels();
  }

  @override
  Future<ChannelEntity> createChannel({
    required String name,
    required String color,
  }) {
    return remoteDataSource.createChannel(name: name, color: color);
  }

  @override
  Future<ChannelEntity> updateChannel({
    required String id,
    required String name,
    required String color,
  }) {
    return remoteDataSource.updateChannel(id: id, name: name, color: color);
  }

  @override
  Future<void> deleteChannel({required String id}) {
    return remoteDataSource.deleteChannel(id: id);
  }
}
