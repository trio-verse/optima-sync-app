import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/analytics_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class AnalyticsRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  AnalyticsRemoteDataSource({
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

  Map<String, dynamic> _unwrap(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return json;
  }

  Future<MarketingDashboardEntity> getDashboard() async {
    final organizationId = await _requireOrganizationId();

    final data = await client.get<Map<String, dynamic>>(
      "${ApiConstants.baseUrl}/api/v1/marketing/analytics",
      (json) => _unwrap(json),
      organizationId: organizationId,
    );

    final merged = <String, dynamic>{...data!};

    if (merged['expected_content'] == null) {
      merged['expected_content'] = await _sumExpectedContent(organizationId);
    }

    return MarketingDashboardEntity.fromJson(merged);
  }

  Future<int> _sumExpectedContent(String organizationId) async {
    try {
      final total = await client.get<int>(
        "${ApiConstants.baseUrl}/api/v1/campaigns",
        (json) {
          final data = json['data'];
          final list = data is List ? data : const [];
          var sum = 0;
          for (final item in list.whereType<Map>()) {
            final value = item['estimated_content_count'];
            sum += value is num
                ? value.toInt()
                : int.tryParse(value?.toString() ?? '') ?? 0;
          }
          return sum;
        },
        organizationId: organizationId,
      );
      return total ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<List<EffectiveCampaignEntity>> getEffectiveCampaigns() async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<List<EffectiveCampaignEntity>>(
      "${ApiConstants.baseUrl}/api/v1/marketing/analytics/effective-campaigns",
      (json) {
        final data = json['data'] ?? json['campaigns'] ?? json;
        final list = data is List ? data : [data];

        return list
            .whereType<Map>()
            .map(
              (e) => EffectiveCampaignEntity.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList();
      },
      organizationId: organizationId,
    );

    return result!;
  }

  Future<CampaignAnalyticsEntity> getCampaignAnalytics(
    String campaignId,
  ) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<CampaignAnalyticsEntity>(
      "${ApiConstants.baseUrl}/api/v1/campaigns/$campaignId/analytics",
      (json) => CampaignAnalyticsEntity.fromJson(_unwrap(json)),
      organizationId: organizationId,
    );

    return result!;
  }
}
