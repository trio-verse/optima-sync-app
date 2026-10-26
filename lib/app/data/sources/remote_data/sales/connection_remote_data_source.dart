import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/sales/connection_entity.dart';
import 'package:optima_sync_v2/core/constants/api_paths.dart';
import 'package:optima_sync_v2/core/errors/exceptions/exceptions.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class _ConnectionPage {
  final List<ConnectionEntity> connections;
  final int currentPage;
  final int lastPage;

  const _ConnectionPage({required this.connections, required this.currentPage, required this.lastPage});
}

class ConnectionRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  ConnectionRemoteDataSource({required this.client, required this.orgLocalDataSource});

  Future<String> _requireOrganizationId() async {
    final organizationId = await orgLocalDataSource.getSelectedOrganization();

    if (organizationId == null) {
      throw const NoOrganizationException();
    }

    return organizationId;
  }

  List<ConnectionEntity> _parseList(Map<String, dynamic> json) {
    final data = json['data'];
    final list = data is List ? data : (data == null ? [] : [data]);

    final connections = list.map((e) => ConnectionEntity.fromJson(e as Map<String, dynamic>)).toList();

    _sortNewestFirst(connections);
    return connections;
  }

  _ConnectionPage _parsePage(Map<String, dynamic> json) {
    final connections = _parseList(json);
    final meta = json['meta'] is Map ? Map<String, dynamic>.from(json['meta'] as Map) : json;

    final currentPage = int.tryParse('${meta['current_page'] ?? 1}') ?? 1;
    final lastPage = int.tryParse('${meta['last_page'] ?? currentPage}') ?? currentPage;

    return _ConnectionPage(connections: connections, currentPage: currentPage, lastPage: lastPage);
  }

  void _sortNewestFirst(List<ConnectionEntity> connections) {
    connections.sort((a, b) {
      final aDate = a.createdAt;
      final bDate = b.createdAt;

      return bDate.compareTo(aDate);
    });
  }

  Future<List<ConnectionEntity>> getClientConnections(String clientId) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<List<ConnectionEntity>>(
      '${ApiPaths.baseUrl}/api/v1/clients/$clientId/connections',
      _parseList,
      organizationId: organizationId,
    );

    return result!;
  }

  Future<List<ConnectionEntity>> getAllConnections() async {
    final organizationId = await _requireOrganizationId();

    print('========== CONNECTIONS DEBUG ==========');
    print('Organization ID: $organizationId');
    print('Starting getAllConnections...');
    print('=======================================');

    final allConnections = <ConnectionEntity>[];
    var page = 1;
    var lastPage = 1;

    do {
      final uri = Uri.parse(
        '${ApiPaths.baseUrl}/api/v1/connections',
      ).replace(queryParameters: {'per_page': '100', 'page': page.toString(), 'sort': 'desc', 'order': 'created_at'});

      print('========== CONNECTION REQUEST ==========');
      print('Page: $page');
      print('URL: $uri');
      print('Organization ID: $organizationId');
      print('========================================');

      final result = await client.get<_ConnectionPage>(uri.toString(), (json) {
        print('========== RAW API RESPONSE ==========');
        print('JSON: $json');
        print('======================================');

        final parsedPage = _parsePage(json);

        print('========== PARSED RESPONSE ==========');
        print('Connections count: ${parsedPage.connections.length}');
        print('Current page: ${parsedPage.currentPage}');
        print('Last page: ${parsedPage.lastPage}');
        print('=====================================');

        return parsedPage;
      }, organizationId: organizationId);

      print('========== CONNECTION RESULT ==========');
      print('Result is null: ${result == null}');

      if (result != null) {
        print('Connections received: ${result.connections.length}');
        print('Current page: ${result.currentPage}');
        print('Last page: ${result.lastPage}');
      }

      print('=======================================');

      if (result == null) break;

      allConnections.addAll(result.connections);
      lastPage = result.lastPage;
      page = result.currentPage + 1;
    } while (page <= lastPage && page <= 100);

    _sortNewestFirst(allConnections);

    print('========== FINAL RESULT ==========');
    print('Total connections: ${allConnections.length}');
    print('==================================');

    return allConnections;
  }

  Future<ConnectionEntity> createConnection(ConnectionEntity connection) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.post<ConnectionEntity>(
      '${ApiPaths.baseUrl}/api/v1/clients/${connection.clientId}/connections',
      connection.toJson(),
      (json) => ConnectionEntity.fromJson(Map<String, dynamic>.from(json['data'] as Map)),
      organizationId: organizationId,
    );
    return result!;
  }

  Future<ConnectionEntity> updateConnection(ConnectionEntity connection) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.patch<ConnectionEntity>(
      '${ApiPaths.baseUrl}/api/v1/connections/${connection.id}',
      connection.toJson(),
      (json) => ConnectionEntity.fromJson(Map<String, dynamic>.from(json['data'] as Map)),
      organizationId: organizationId,
    );
    return result!;
  }

  Future<void> deleteConnection(String id) async {
    final organizationId = await _requireOrganizationId();

    await client.delete('${ApiPaths.baseUrl}/api/v1/connections/$id', organizationId: organizationId);
  }
}
