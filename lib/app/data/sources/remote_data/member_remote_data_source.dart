import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class MemberRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  MemberRemoteDataSource({
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

  Future<List<MemberEntity>> getMembers() async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<List<MemberEntity>>(
      "${ApiConstants.baseUrl}/api/v1/organizations/$organizationId/members",
      (json) {
        final data = json["data"];

        if (data is! List) return <MemberEntity>[];

        return data
            .map((e) => MemberEntity.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      organizationId: organizationId,
    );

    return result ?? [];
  }

  Future<MemberEntity> addMember({
    required String email,
    required String role,
  }) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.post<MemberEntity>(
      "${ApiConstants.baseUrl}/api/v1/organizations/$organizationId/members",
      {"email": email, "role": role},
      (json) {
        return MemberEntity.fromJson(json["data"]);
      },
      organizationId: organizationId,
      acceptedStatusCodes: const [200, 201],
    );

    return result!;
  }

  Future<void> updateMemberRole({
    required String memberId,
    required String role,
  }) async {
    final organizationId = await _requireOrganizationId();

    await client.patch<Map<String, dynamic>>(
      "${ApiConstants.baseUrl}/api/v1/organizations/$organizationId/members/$memberId",
      {"role": role},
      (json) => json,
      organizationId: organizationId,
    );
  }
}
