import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class ChannelRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  ChannelRemoteDataSource({
    required this.client,
    required this.orgLocalDataSource,
  });

  Future<List<ChannelEntity>> getChannels() async {
    final organizationId = await orgLocalDataSource.getSelectedOrganization();

    if (organizationId == null) {
      throw Exception('No selected organization found');
    }

    final result = await client.get<List<ChannelEntity>>(
      "${ApiConstants.baseUrl}/api/v1/channels",
      (json) {
        return (json["data"] as List)
            .map((e) => ChannelEntity.fromJson(e))
            .toList();
      },
      organizationId: organizationId,
    );

    return result!;
  }

  Future<ChannelEntity> createChannel({
    required String name,
    required String color,
  }) async {
    final organizationId = await orgLocalDataSource.getSelectedOrganization();

    if (organizationId == null) {
      throw Exception('No selected organization found');
    }

    final result = await client.post<ChannelEntity>(
      "${ApiConstants.baseUrl}/api/v1/channels",
      {"name": name, "color": color},
      (json) {
        return ChannelEntity.fromJson(json["data"]);
      },
      organizationId: organizationId,
    );

    return result!;
  }

  Future<ChannelEntity> updateChannel({
    required String id,
    required String name,
    required String color,
  }) async {
    final organizationId = await orgLocalDataSource.getSelectedOrganization();

    if (organizationId == null) {
      throw Exception('No selected organization found');
    }

    final result = await client.patch<ChannelEntity>(
      "${ApiConstants.baseUrl}/api/v1/channels/$id",
      {"name": name, "color": color},
      (json) {
        return ChannelEntity.fromJson(json["data"]);
      },
      organizationId: organizationId,
    );

    return result!;
  }

  Future<void> deleteChannel({required String id}) async {
    final organizationId = await orgLocalDataSource.getSelectedOrganization();

    if (organizationId == null) {
      throw Exception('No selected organization found');
    }

    await client.delete(
      "${ApiConstants.baseUrl}/api/v1/channels/$id",
      organizationId: organizationId,
    );
  }
}
