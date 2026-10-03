import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/content_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class ContentRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  ContentRemoteDataSource({
    required this.client,
    required this.orgLocalDataSource,
  });

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

    return list
        .whereType<Map>()
        .map((e) => ContentEntity.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  ContentEntity _parseSingle(Map<String, dynamic> json) {
    final data = json["data"];

    if (data is Map) {
      return ContentEntity.fromJson(Map<String, dynamic>.from(data));
    }

    if (data is List && data.isNotEmpty) {
      return ContentEntity.fromJson(
        Map<String, dynamic>.from(data.first as Map),
      );
    }

    throw Exception('Expected content data but received none');
  }

  Future<List<ContentEntity>> getCampaignContents(String campaignId) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<List<ContentEntity>>(
      "${ApiConstants.baseUrl}/api/v1/campaigns/$campaignId/contents",
      _parseList,
      organizationId: organizationId,
    );

    return result!;
  }

  Future<ContentEntity> getContent({
    required String campaignId,
    required String id,
  }) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<ContentEntity>(
      "${ApiConstants.baseUrl}/api/v1/campaigns/$campaignId/contents/$id",
      _parseSingle,
      organizationId: organizationId,
    );

    return result!;
  }

  Future<ContentEntity> createContent({
    required String campaignId,
    required ContentEntity content,
  }) async {
    final organizationId = await _requireOrganizationId();

    ContentEntity? fallback;

    final result = await client.post<ContentEntity>(
      "${ApiConstants.baseUrl}/api/v1/campaigns/$campaignId/contents",
      content.toJson(),
      (json) {
        final data = json["data"];

        if (data is Map && data.isNotEmpty) {
          return ContentEntity.fromJson(Map<String, dynamic>.from(data));
        }

        if (data is List && data.isNotEmpty) {
          return ContentEntity.fromJson(
            Map<String, dynamic>.from(data.first as Map),
          );
        }

        fallback = content.copyWith(campaignId: campaignId);
        return fallback!;
      },
      organizationId: organizationId,
    );

    return result ?? fallback!;
  }

  Future<ContentEntity> updateContent({
    required String campaignId,
    required String id,
    required ContentEntity content,
  }) async {
    final organizationId = await _requireOrganizationId();

    final localFallback = content.copyWith(id: id, campaignId: campaignId);

    final result = await client.patch<ContentEntity>(
      "${ApiConstants.baseUrl}/api/v1/campaigns/$campaignId/contents/$id",
      content.toJson(),
      (json) {
        final data = json["data"];

        if (data is Map && data.isNotEmpty) {
          return ContentEntity.fromJson(Map<String, dynamic>.from(data));
        }

        if (data is List && data.isNotEmpty) {
          return ContentEntity.fromJson(
            Map<String, dynamic>.from(data.first as Map),
          );
        }

        return localFallback;
      },
      organizationId: organizationId,
    );

    return result ?? localFallback;
  }

  Future<void> deleteContent({
    required String campaignId,
    required String id,
  }) async {
    final organizationId = await _requireOrganizationId();

    await client.delete(
      "${ApiConstants.baseUrl}/api/v1/campaigns/$campaignId/contents/$id",
      organizationId: organizationId,
    );
  }
}
