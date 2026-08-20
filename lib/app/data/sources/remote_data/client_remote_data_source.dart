import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class ClientRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  ClientRemoteDataSource({
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

  Future<ClientListResult> getClients(ClientFilter filter) async {
    final organizationId = await _requireOrganizationId();

    final uri = Uri.parse(
      "${ApiConstants.baseUrl}/api/v1/clients",
    ).replace(queryParameters: filter.toQueryParameters());

    final result = await client.get<ClientListResult>(uri.toString(), (json) {
      final data = (json["data"] as List)
          .map((e) => ClientEntity.fromJson(e))
          .toList();

      final meta = (json["meta"] is Map<String, dynamic>)
          ? json["meta"] as Map<String, dynamic>
          : json;

      final currentPage = int.tryParse('${meta["current_page"] ?? 1}') ?? 1;
      final lastPage =
          int.tryParse('${meta["last_page"] ?? currentPage}') ?? currentPage;

      return ClientListResult(
        clients: data,
        currentPage: currentPage,
        lastPage: lastPage,
      );
    }, organizationId: organizationId);

    return result!;
  }

  Future<ClientEntity> createClient(ClientEntity client_) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.post<ClientEntity>(
      "${ApiConstants.baseUrl}/api/v1/clients",
      client_.toJson(),
      (json) {
        final data = json["data"];

        return ClientEntity.fromJson(Map<String, dynamic>.from(data));
      },
      organizationId: organizationId,
    );

    return result!;
  }

  Future<ClientEntity> updateClient({
    required String id,
    required ClientEntity client_,
  }) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.patch<ClientEntity>(
      "${ApiConstants.baseUrl}/api/v1/clients/$id",
      client_.toJson(),
      (json) {
        final data = json["data"];

        return ClientEntity.fromJson(Map<String, dynamic>.from(data));
      },
      organizationId: organizationId,
    );

    return result!;
  }
}
