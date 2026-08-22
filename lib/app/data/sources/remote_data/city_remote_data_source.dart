import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class CityRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  CityRemoteDataSource({
    required this.client,
    required this.orgLocalDataSource,
  });

  Future<List<CityEntity>> getCities() async {
    final organizationId = await orgLocalDataSource.getSelectedOrganization();

    if (organizationId == null) {
      throw Exception('No selected organization found');
    }

    final result = await client.get<List<CityEntity>>(
      "${ApiConstants.baseUrl}/api/v1/cities",
      (json) {
        return (json["data"] as List)
            .map((e) => CityEntity.fromJson(e))
            .toList();
      },
      organizationId: organizationId,
    );

    return result!;
  }

  Future<CityEntity> createCity({
    required String name,
    required String color,
  }) async {
    final organizationId = await orgLocalDataSource.getSelectedOrganization();

    if (organizationId == null) {
      throw Exception('No selected organization found');
    }

    final result = await client.post<CityEntity>(
      "${ApiConstants.baseUrl}/api/v1/cities",
      {"name": name, "color": color},
      (json) {
        return CityEntity.fromJson(json["data"]);
      },
      organizationId: organizationId,
    );

    return result!;
  }
}
