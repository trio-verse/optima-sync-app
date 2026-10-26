import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/content_entity.dart';
import 'package:optima_sync_v2/core/constants/api_paths.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class ContentRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  ContentRemoteDataSource({required this.client, required this.orgLocalDataSource});

  Future<String> _requireOrganizationId() async {
    final organizationId = await orgLocalDataSource.getSelectedOrganization();

    if (organizationId == null) {
      throw Exception('No selected organization found');
    }

    return organizationId;
  }

  Future<List<ContentEntity>> getCampaignContents(String campaign) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<List<ContentEntity>>("${ApiPaths.baseUrl}/api/v1/campaigns/$campaign/contents", (
      json,
    ) {
      final data = json["data"];

      return data.whereType<Map>().map((e) => ContentEntity.fromJson(Map<String, dynamic>.from(e))).toList();
    }, organizationId: organizationId);

    return result!;
  }

  Future<ContentEntity> getContent(String contentId, String campaignId) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<ContentEntity>(ApiPaths.contentEdit(campaignId, contentId), (json) {
      final data = json["data"];

      return ContentEntity.fromJson(Map<String, dynamic>.from(data));
    }, organizationId: organizationId);

    return result!;
  }

  Future<ContentEntity> createContent(ContentEntity content) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.post<ContentEntity>(
      "${ApiPaths.baseUrl}/api/v1/campaigns/${content.campaignId}/contents",
      content.toJson(),
      (json) {
        final data = json["data"];

        return ContentEntity.fromJson(Map<String, dynamic>.from(data));
      },
      organizationId: organizationId,
    );

    return result!;
  }

  Future<ContentEntity> updateContent(ContentEntity content) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.patch<ContentEntity>(
      ApiPaths.contentEdit(content.campaignId, content.contentId!),
      content.toJson(),
      (json) {
        final data = json["data"];

        return ContentEntity.fromJson(Map<String, dynamic>.from(data));
      },
      organizationId: organizationId,
    );

    return result!;
  }

  Future<void> deleteContent(String contentId, String campaignId) async {
    final organizationId = await _requireOrganizationId();

    await client.delete(ApiPaths.contentEdit(campaignId, contentId), organizationId: organizationId);
  }
}
