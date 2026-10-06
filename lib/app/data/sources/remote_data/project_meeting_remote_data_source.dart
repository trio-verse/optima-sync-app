import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/project_meeting_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class ProjectMeetingRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  ProjectMeetingRemoteDataSource({
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

  Future<List<ProjectMeetingEntity>> getMeetings(String projectId) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<List<ProjectMeetingEntity>>(
      "${ApiConstants.baseUrl}/api/v1/projects/$projectId/meetings",
      (json) {
        final data = json["data"];
        final list = data is List ? data : (data == null ? [] : [data]);

        final meetings = list
            .whereType<Map>()
            .map(
              (e) => ProjectMeetingEntity.fromJson(
                Map<String, dynamic>.from(e),
                projectId: projectId,
              ),
            )
            .toList();

        meetings.sort((a, b) {
          final aDate = a.meetingDate;
          final bDate = b.meetingDate;
          if (aDate == null && bDate == null) return 0;
          if (aDate == null) return 1;
          if (bDate == null) return -1;
          return aDate.compareTo(bDate);
        });

        return meetings;
      },
      organizationId: organizationId,
    );

    return result!;
  }
}
