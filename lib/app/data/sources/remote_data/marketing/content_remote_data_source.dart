import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
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

  List<ContentEntity> _parseList(Map<String, dynamic> json) {
    final data = json["data"];
    final list = data is List ? data : (data == null ? [] : [data]);

    return list.whereType<Map>().map((e) => ContentEntity.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  ContentEntity _parseSingle(Map<String, dynamic> json) {
    final data = json["data"];

    if (data is Map) {
      return ContentEntity.fromJson(Map<String, dynamic>.from(data));
    }

    if (data is List && data.isNotEmpty) {
      return ContentEntity.fromJson(Map<String, dynamic>.from(data.first as Map));
    }

    throw Exception('Expected content data but received none');
  }

  Future<List<ContentEntity>> getCampaignContents(String campaign) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<List<ContentEntity>>(
      "${ApiPaths.baseUrl}/api/v1/campaigns/$campaign/contents",
      _parseList,
      organizationId: organizationId,
    );

    return result!;
  }

  Future<ContentEntity> getContent(ContentEntity content) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<ContentEntity>(
      "${ApiPaths.baseUrl}/api/v1/campaigns/${content.campaignId}/contents/${content.id}",
      _parseSingle,
      organizationId: organizationId,
    );

    return result!;
  }

  Future<ContentEntity> createContent(ContentEntity content) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.post<ContentEntity>(
      "${ApiPaths.baseUrl}/api/v1/campaigns/${content.campaignId}/contents",
      content.toJson(),
      _parseSingle,
      organizationId: organizationId,
    );

    return result!;
  }

  Future<ContentEntity> updateContent(ContentEntity content) async {
    final organizationId = await _requireOrganizationId();

    final localFallback = content;

    final result = await client.patch<ContentEntity>(
      "${ApiPaths.baseUrl}/api/v1/campaigns/${content.campaignId}/contents/${content.id}",
      content.toJson(),
      (json) {
        final data = json["data"];

        if (data is Map && data.isNotEmpty) {
          return ContentEntity.fromJson(Map<String, dynamic>.from(data));
        }

        if (data is List && data.isNotEmpty) {
          return ContentEntity.fromJson(Map<String, dynamic>.from(data.first as Map));
        }

        return localFallback;
      },
      organizationId: organizationId,
    );

    return result ?? localFallback;
  }

  Future<void> deleteContent(ContentEntity content) async {
    final organizationId = await _requireOrganizationId();

    await client.delete(
      "${ApiPaths.baseUrl}/api/v1/campaigns/${content.campaignId}/contents/${content.id}",
      organizationId: organizationId,
    );
  }
}
