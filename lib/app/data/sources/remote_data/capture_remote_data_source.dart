import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/capture_settings_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

Map<String, dynamic> _unwrap(Map<String, dynamic> json) {
  final data = json['data'];
  if (data is Map) return Map<String, dynamic>.from(data);
  return json;
}

class CaptureRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  CaptureRemoteDataSource({
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

  Future<CaptureSettingsEntity> getCaptureSettings(String campaignId) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<CaptureSettingsEntity>(
      "${ApiConstants.baseUrl}/api/v1/campaigns/$campaignId/capture",
      (json) => CaptureSettingsEntity.fromJson(_unwrap(json)),
      organizationId: organizationId,
    );

    return result!;
  }

  Future<CaptureSettingsEntity> setCaptureEnabled({
    required String campaignId,
    required bool enabled,
  }) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.patch<CaptureSettingsEntity>(
      "${ApiConstants.baseUrl}/api/v1/campaigns/$campaignId/capture",
      {"enabled": enabled},
      (json) => CaptureSettingsEntity.fromJson(_unwrap(json)),
      organizationId: organizationId,
    );

    return result!;
  }

  Future<CaptureSettingsEntity> regenerateToken(String campaignId) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.post<CaptureSettingsEntity>(
      "${ApiConstants.baseUrl}/api/v1/campaigns/$campaignId/capture/regenerate",
      const {},
      (json) => CaptureSettingsEntity.fromJson(_unwrap(json)),
      organizationId: organizationId,
      acceptedStatusCodes: const [200, 201],
    );

    return result!;
  }
}
