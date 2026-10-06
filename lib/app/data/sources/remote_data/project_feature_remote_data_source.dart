import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/project_feature_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class ProjectFeatureRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  ProjectFeatureRemoteDataSource({
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

  List<ProjectFeatureEntity> _parseList(
    Map<String, dynamic> json,
    String projectId,
  ) {
    final data = json["data"];
    final list = data is List ? data : (data == null ? [] : [data]);

    return list
        .whereType<Map>()
        .map(
          (e) => ProjectFeatureEntity.fromJson(
            Map<String, dynamic>.from(e),
            projectId: projectId,
          ),
        )
        .toList();
  }

  Future<List<ProjectFeatureEntity>> getFeatures(String projectId) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<List<ProjectFeatureEntity>>(
      "${ApiConstants.baseUrl}/api/v1/projects/$projectId/features",
      (json) => _parseList(json, projectId),
      organizationId: organizationId,
    );

    return result!;
  }

  Future<ProjectFeatureEntity> updateFeatureStatus({
    required String projectId,
    required String featureId,
    required String status,
    required ProjectFeatureEntity current,
  }) async {
    final organizationId = await _requireOrganizationId();

    final localFallback = current.copyWith(status: status);

    final result = await client.patch<ProjectFeatureEntity>(
      "${ApiConstants.baseUrl}/api/v1/projects/$projectId/features/$featureId/status",
      {"status": status},
      (json) {
        final data = json["data"];

        if (data is Map && data.isNotEmpty) {
          return ProjectFeatureEntity.fromJson(
            Map<String, dynamic>.from(data),
            projectId: projectId,
          );
        }

        return localFallback;
      },
      organizationId: organizationId,
    );

    return result ?? localFallback;
  }
}
