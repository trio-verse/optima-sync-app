import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/campaign_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';


Map<String, dynamic> _asSingleObject(dynamic data) {
  if (data is List) {
    if (data.isEmpty) {
      throw Exception('Expected campaign data but received an empty list');
    }
    return Map<String, dynamic>.from(data.first as Map);
  }

  return Map<String, dynamic>.from(data as Map);
}

class CampaignRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  CampaignRemoteDataSource({
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

  Future<List<CampaignEntity>> getCampaigns() async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<List<CampaignEntity>>(
      "${ApiConstants.baseUrl}/api/v1/campaigns",
      (json) {
        final data = json["data"];
        final list = data is List ? data : [data];

        return list
            .map((e) => CampaignEntity.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      },
      organizationId: organizationId,
    );

    return result!;
  }

  Future<CampaignEntity> createCampaign(CampaignEntity campaign) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.post<CampaignEntity>(
      "${ApiConstants.baseUrl}/api/v1/campaigns",
      campaign.toJson(),
      (json) => CampaignEntity.fromJson(_asSingleObject(json["data"])),
      organizationId: organizationId,
    );

    return result!;
  }

  Future<CampaignEntity> updateCampaign({
    required String id,
    required CampaignEntity campaign,
  }) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.patch<CampaignEntity>(
      "${ApiConstants.baseUrl}/api/v1/campaigns/$id",
      campaign.toJson(),
      (json) => CampaignEntity.fromJson(_asSingleObject(json["data"])),
      organizationId: organizationId,
    );

    return result!;
  }

  Future<void> deleteCampaign(String id) async {
    final organizationId = await _requireOrganizationId();

    await client.delete(
      "${ApiConstants.baseUrl}/api/v1/campaigns/$id",
      organizationId: organizationId,
    );
  }
}
