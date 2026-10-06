import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/employee_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_details_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_feature_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_meeting_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class ProjectRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  ProjectRemoteDataSource({
    required this.client,
    required this.orgLocalDataSource,
  });

  Future<String> _requireOrganizationId() async {
    final organizationId = await orgLocalDataSource.getSelectedOrganization();
    if (organizationId == null || organizationId.isEmpty) {
      throw Exception('No selected organization found');
    }
    return organizationId;
  }

  List<dynamic> _dataList(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is List) return data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    return const [];
  }

  Map<String, dynamic> _dataMap(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return json;
  }

  Future<ProjectListResult> getProjects(ProjectFilter filter) async {
    final organizationId = await _requireOrganizationId();
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/api/v1/projects',
    ).replace(queryParameters: filter.toQueryParameters());
    final result = await client.get<ProjectListResult>(uri.toString(), (json) {
      final projects = _dataList(json)
          .whereType<Map>()
          .map(
            (item) => ProjectEntity.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
      final raw = json['data'];
      final nestedMeta = raw is Map ? raw : null;
      final meta = json['meta'] is Map
          ? Map<String, dynamic>.from(json['meta'] as Map)
          : nestedMeta == null
          ? json
          : Map<String, dynamic>.from(nestedMeta);
      final currentPage = int.tryParse('${meta['current_page'] ?? 1}') ?? 1;
      final lastPage =
          int.tryParse('${meta['last_page'] ?? currentPage}') ?? currentPage;
      return ProjectListResult(
        projects: projects,
        currentPage: currentPage,
        lastPage: lastPage,
      );
    }, organizationId: organizationId);
    return result!;
  }

  Future<List<ProjectClientOption>> getClients() async {
    final organizationId = await _requireOrganizationId();
    final result = await client.get<List<ProjectClientOption>>(
      '${ApiConstants.baseUrl}/api/v1/clients?per_page=100',
      (json) => _dataList(json)
          .whereType<Map>()
          .map((item) {
            final map = Map<String, dynamic>.from(item);
            return ProjectClientOption(
              id: '${map['id'] ?? ''}',
              name:
                  '${map['name'] ?? map['company_name'] ?? map['email'] ?? 'Client'}',
            );
          })
          .where((option) => option.id.isNotEmpty)
          .toList(),
      organizationId: organizationId,
    );
    return result ?? [];
  }

  Future<ProjectEntity> createProject(ProjectInput input) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.post<ProjectEntity>(
      '${ApiConstants.baseUrl}/api/v1/projects',
      input.toJson(),
      (json) => ProjectEntity.fromJson(_dataMap(json)),
      organizationId: organizationId,
      acceptedStatusCodes: const [200, 201],
    );
    return result!;
  }

  Future<ProjectEntity> updateProject(
    String projectId,
    ProjectUpdateInput input,
  ) async {
    final organizationId = await _requireOrganizationId();
    final updated = await client.patch<ProjectEntity>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId',
      input.toProjectJson(),
      (json) => ProjectEntity.fromJson(_dataMap(json)),
      organizationId: organizationId,
    );
    var versionId = input.versionId ?? updated?.currentVersionId;
    if (versionId == null || versionId.isEmpty) {
      final versions = await _orDefault(
        getVersions(projectId),
        const <ProjectVersionEntity>[],
      );
      for (final version in versions) {
        if (version.isActive) versionId = version.id;
      }
      if ((versionId == null || versionId.isEmpty) && versions.isNotEmpty) {
        versionId = versions.first.id;
      }
    }
    if (versionId != null && versionId.isNotEmpty) {
      await client.patch<Object?>(
        '${ApiConstants.baseUrl}/api/v1/projects/$projectId/versions/$versionId',
        input.toVersionJson(),
        (json) => json,
        organizationId: organizationId,
      );
    }
    return updated!;
  }

  Future<void> deleteProject(String projectId) async {
    final organizationId = await _requireOrganizationId();
    await client.delete(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId',
      organizationId: organizationId,
    );
  }

  Future<ProjectEntity> getProject(String projectId) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.get<ProjectEntity>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId',
      (json) => ProjectEntity.fromJson(_dataMap(json)),
      organizationId: organizationId,
    );
    return result!;
  }

  Future<List<ProjectVersionEntity>> getVersions(String projectId) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.get<List<ProjectVersionEntity>>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/versions',
      (json) => _dataList(json)
          .whereType<Map>()
          .map(
            (item) =>
                ProjectVersionEntity.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      organizationId: organizationId,
    );
    return result ?? [];
  }

  Future<List<ProjectFeatureEntity>> getFeatures(String projectId) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.get<List<ProjectFeatureEntity>>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/features',
      (json) => _dataList(json)
          .whereType<Map>()
          .map(
            (item) => ProjectFeatureEntity.fromJson(
              Map<String, dynamic>.from(item),
              projectId: projectId,
            ),
          )
          .toList(),
      organizationId: organizationId,
    );
    return result ?? [];
  }

  Future<ProjectFeatureEntity> createFeature(
    String projectId,
    ProjectFeatureInput input,
  ) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.post<ProjectFeatureEntity>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/features',
      input.toJson(),
      (json) =>
          ProjectFeatureEntity.fromJson(_dataMap(json), projectId: projectId),
      organizationId: organizationId,
      acceptedStatusCodes: const [200, 201],
    );
    return result!;
  }

  Future<ProjectFeatureEntity> updateFeature(
    String projectId,
    String featureId,
    ProjectFeatureInput input,
  ) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.patch<ProjectFeatureEntity>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/features/$featureId',
      input.toJson(),
      (json) =>
          ProjectFeatureEntity.fromJson(_dataMap(json), projectId: projectId),
      organizationId: organizationId,
    );
    return result!;
  }

  Future<void> deleteFeature(String projectId, String featureId) async {
    final organizationId = await _requireOrganizationId();
    await client.delete(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/features/$featureId',
      organizationId: organizationId,
    );
  }

  Future<List<ProjectCostEntity>> getCosts(String projectId) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.get<List<ProjectCostEntity>>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/costs',
      (json) => _dataList(json)
          .whereType<Map>()
          .map(
            (item) =>
                ProjectCostEntity.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      organizationId: organizationId,
    );
    return result ?? [];
  }

  Future<ProjectCostEntity> createCost(
    String projectId,
    ProjectCostInput input,
  ) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.post<ProjectCostEntity>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/costs',
      input.toJson(),
      (json) => ProjectCostEntity.fromJson(_dataMap(json)),
      organizationId: organizationId,
      acceptedStatusCodes: const [200, 201],
    );
    return result!;
  }

  Future<ProjectCostEntity> updateCost(
    String projectId,
    String costId,
    ProjectCostInput input,
  ) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.patch<ProjectCostEntity>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/costs/$costId',
      input.toJson(),
      (json) => ProjectCostEntity.fromJson(_dataMap(json)),
      organizationId: organizationId,
    );
    return result!;
  }

  Future<void> deleteCost(String projectId, String costId) async {
    final organizationId = await _requireOrganizationId();
    await client.delete(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/costs/$costId',
      organizationId: organizationId,
    );
  }

  Future<List<ProjectEmployeeEntity>> getProjectEmployees(
    String projectId,
  ) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.get<List<ProjectEmployeeEntity>>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/employees',
      (json) => _dataList(json)
          .whereType<Map>()
          .map(
            (item) =>
                ProjectEmployeeEntity.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      organizationId: organizationId,
    );
    return result ?? [];
  }

  Future<List<EmployeeEntity>> getAvailableEmployees() async {
    final organizationId = await _requireOrganizationId();
    final result = await client.get<List<EmployeeEntity>>(
      '${ApiConstants.baseUrl}/api/v1/hr/employees',
      (json) => _dataList(json)
          .whereType<Map>()
          .map(
            (item) => EmployeeEntity.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      organizationId: organizationId,
    );
    return result ?? [];
  }

  Future<ProjectEmployeeEntity> addProjectEmployee(
    String projectId,
    String employeeId,
    int totalPoints,
  ) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.post<ProjectEmployeeEntity>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/employees',
      {
        'employee_id': int.tryParse(employeeId) ?? employeeId,
        'total_points': totalPoints,
      },
      (json) => ProjectEmployeeEntity.fromJson(_dataMap(json)),
      organizationId: organizationId,
      acceptedStatusCodes: const [200, 201],
    );
    return result!;
  }

  Future<ProjectEmployeeEntity> updateProjectEmployee(
    String projectId,
    String assignmentId,
    int totalPoints,
  ) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.patch<ProjectEmployeeEntity>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/employees/$assignmentId',
      {'total_points': totalPoints},
      (json) => ProjectEmployeeEntity.fromJson(_dataMap(json)),
      organizationId: organizationId,
    );
    return result!;
  }

  Future<void> deleteProjectEmployee(
    String projectId,
    String assignmentId,
  ) async {
    final organizationId = await _requireOrganizationId();
    await client.delete(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/employees/$assignmentId',
      organizationId: organizationId,
    );
  }

  Future<List<ProjectMeetingEntity>> getMeetings(String projectId) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.get<List<ProjectMeetingEntity>>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/meetings',
      (json) => _dataList(json)
          .whereType<Map>()
          .map(
            (item) => ProjectMeetingEntity.fromJson(
              Map<String, dynamic>.from(item),
              projectId: projectId,
            ),
          )
          .toList(),
      organizationId: organizationId,
    );
    return result ?? [];
  }

  Future<ProjectMeetingEntity> createMeeting(
    String projectId,
    ProjectMeetingInput input,
  ) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.post<ProjectMeetingEntity>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/meetings',
      input.toJson(),
      (json) =>
          ProjectMeetingEntity.fromJson(_dataMap(json), projectId: projectId),
      organizationId: organizationId,
      acceptedStatusCodes: const [200, 201],
    );
    return result!;
  }

  Future<ProjectMeetingEntity> updateMeeting(
    String projectId,
    String meetingId,
    ProjectMeetingInput input,
  ) async {
    final organizationId = await _requireOrganizationId();
    final result = await client.patch<ProjectMeetingEntity>(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/meetings/$meetingId',
      input.toJson(),
      (json) =>
          ProjectMeetingEntity.fromJson(_dataMap(json), projectId: projectId),
      organizationId: organizationId,
    );
    return result!;
  }

  Future<void> deleteMeeting(String projectId, String meetingId) async {
    final organizationId = await _requireOrganizationId();
    await client.delete(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/meetings/$meetingId',
      organizationId: organizationId,
    );
  }

  Future<String> previewQuotation(String projectId, String versionId) async {
    final organizationId = await _requireOrganizationId();
    return client.getText(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/versions/$versionId/quotations/preview',
      organizationId: organizationId,
    );
  }

  Future<String> generateQuotationPdf(
    String projectId,
    String versionId,
  ) async {
    final organizationId = await _requireOrganizationId();
    return client.postText(
      '${ApiConstants.baseUrl}/api/v1/projects/$projectId/versions/$versionId/quotations/generate-pdf',
      organizationId: organizationId,
    );
  }

  Future<T> _orDefault<T>(Future<T> request, T fallback) async {
    try {
      return await request;
    } catch (_) {
      return fallback;
    }
  }

  Future<ProjectDetailsData> getProjectDetails(String projectId) async {
    final project = await getProject(projectId);
    final versions = await _orDefault(
      getVersions(projectId),
      const <ProjectVersionEntity>[],
    );
    final features = await _orDefault(
      getFeatures(projectId),
      const <ProjectFeatureEntity>[],
    );
    final costs = await _orDefault(
      getCosts(projectId),
      const <ProjectCostEntity>[],
    );
    final team = await _orDefault(
      getProjectEmployees(projectId),
      const <ProjectEmployeeEntity>[],
    );
    final meetings = await _orDefault(
      getMeetings(projectId),
      const <ProjectMeetingEntity>[],
    );
    final employees = await _orDefault(
      getAvailableEmployees(),
      const <EmployeeEntity>[],
    );
    String? selectedVersionId = project.currentVersionId;
    if (selectedVersionId != null &&
        !versions.any((version) => version.id == selectedVersionId)) {
      selectedVersionId = null;
    }
    if (selectedVersionId == null) {
      for (final version in versions) {
        if (version.isActive) {
          selectedVersionId = version.id;
          break;
        }
      }
    }
    if (selectedVersionId == null && versions.isNotEmpty) {
      selectedVersionId = versions.first.id;
    }

    return ProjectDetailsData(
      project: project,
      versions: versions,
      features: features,
      costs: costs,
      team: team,
      meetings: meetings,
      availableEmployees: employees,
      selectedVersionId: selectedVersionId,
    );
  }
}
