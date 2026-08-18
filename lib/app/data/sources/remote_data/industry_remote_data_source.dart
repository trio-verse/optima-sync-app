import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class IndustryRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  IndustryRemoteDataSource({
    required this.client,
    required this.orgLocalDataSource,
  });

  Future<List<IndustryEntity>> getIndustries() async {
    final organizationId = await orgLocalDataSource.getSelectedOrganization();

    if (organizationId == null) {
      throw Exception('No selected organization found');
    }

    final result = await client.get<List<IndustryEntity>>(
      "${ApiConstants.baseUrl}/api/v1/industries",
      (json) {
        return (json["data"] as List)
            .map((e) => IndustryEntity.fromJson(e))
            .toList();
      },
      organizationId: organizationId,
    );

    return result!;
  }

  Future<IndustryEntity> createIndustry(String newName, String newColor) async {
    final organizationId = await orgLocalDataSource.getSelectedOrganization();

    if (organizationId == null) {
      throw Exception('No selected organization found');
    }

    final result = await client.post<IndustryEntity>(
      "${ApiConstants.baseUrl}/api/v1/industries",
      {"name": newName, "color": newColor},
      (json) {
        return IndustryEntity.fromJson(json["data"]);
      },
      organizationId: organizationId,
    );

    return result!;
  }
}
