import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/core/constants/api_paths.dart';
import 'package:optima_sync_v2/core/errors/exceptions/exceptions.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class CampaignRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  CampaignRemoteDataSource({required this.client, required this.orgLocalDataSource});

  Future<String> _requireOrganizationId() async {
    final organizationId = await orgLocalDataSource.getSelectedOrganization();

    if (organizationId == null) {
      throw const NoOrganizationException();
    }

    return organizationId;
  }

  Future<List<CampaignEntity>> getCampaigns() async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<List<CampaignEntity>>(ApiPaths.campaigns, (json) {
      final data = json["data"];

      return data.map((e) => CampaignEntity.fromJson(Map<String, dynamic>.from(e))).toList();
    }, organizationId: organizationId);

    return result!;
  }

  Future<CampaignEntity> createCampaign(CampaignEntity campaign) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.post<CampaignEntity>(
      ApiPaths.campaigns,
      campaign.toJson(),
      (json) => CampaignEntity.fromJson((json["data"])),
      organizationId: organizationId,
    );

    return result!;
  }

  Future<CampaignEntity> updateCampaign(CampaignEntity campaign) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.patch<CampaignEntity>(
      ApiPaths.campaignEdit(campaign.id!),
      campaign.toJson(),
      (json) => CampaignEntity.fromJson(Map<String, dynamic>.from(json["data"])),
      organizationId: organizationId,
    );

    return result!;
  }

  Future<void> deleteCampaign(CampaignEntity campaign) async {
    final organizationId = await _requireOrganizationId();

    await client.delete(ApiPaths.campaignEdit(campaign.id!), organizationId: organizationId);
  }
}
