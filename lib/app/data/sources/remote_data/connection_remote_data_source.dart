import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/connection_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class _ConnectionPage {
  final List<ConnectionEntity> connections;
  final int currentPage;
  final int lastPage;

  const _ConnectionPage({
    required this.connections,
    required this.currentPage,
    required this.lastPage,
  });
}

class ConnectionRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  ConnectionRemoteDataSource({
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

  List<ConnectionEntity> _parseList(Map<String, dynamic> json) {
    final data = json['data'];
    final list = data is List ? data : (data == null ? [] : [data]);

    final connections = list
        .whereType<Map>()
        .map((e) => ConnectionEntity.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    _sortNewestFirst(connections);
    return connections;
  }

  _ConnectionPage _parsePage(Map<String, dynamic> json) {
    final connections = _parseList(json);
    final meta = json['meta'] is Map
        ? Map<String, dynamic>.from(json['meta'] as Map)
        : json;

    final currentPage = int.tryParse('${meta['current_page'] ?? 1}') ?? 1;
    final lastPage =
        int.tryParse('${meta['last_page'] ?? currentPage}') ?? currentPage;

    return _ConnectionPage(
      connections: connections,
      currentPage: currentPage,
      lastPage: lastPage,
    );
  }

  void _sortNewestFirst(List<ConnectionEntity> connections) {
    connections.sort((a, b) {
      final aDate = a.createdAt;
      final bDate = b.createdAt;

      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;

      return bDate.compareTo(aDate);
    });
  }

  Future<List<ConnectionEntity>> getClientConnections(String clientId) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<List<ConnectionEntity>>(
      '${ApiConstants.baseUrl}/api/v1/clients/$clientId/connections',
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
      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/connections')
          .replace(
            queryParameters: {
              'per_page': '100',
              'page': page.toString(),
              'sort': 'desc',
              'order': 'created_at',
            },
          );

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
  // Future<ConnectionEntity> getConnection(String connectionId) async {
  //   final organizationId = await _requireOrganizationId();

  //   final result = await client.get<ConnectionEntity>(
  //     '${ApiConstants.baseUrl}/api/v1/connections/$connectionId',
  //     (json) {
  //       final data = json['data'];
  //       return ConnectionEntity.fromJson(Map<String, dynamic>.from(data));
  //     },
  //     organizationId: organizationId,
  //   );

  //   return result!;
  // }

  Future<ConnectionEntity> createConnection({
    required String clientId,
    required ConnectionEntity connection,
  }) async {
    final organizationId = await _requireOrganizationId();

    ConnectionEntity? fallback;

    final result = await client.post<ConnectionEntity>(
      '${ApiConstants.baseUrl}/api/v1/clients/$clientId/connections',
      connection.toJson(),
      (json) {
        final data = json['data'];

        if (data is Map && data.isNotEmpty) {
          return ConnectionEntity.fromJson(Map<String, dynamic>.from(data));
        }

        if (data is List && data.isNotEmpty) {
          return ConnectionEntity.fromJson(
            Map<String, dynamic>.from(data.first as Map),
          );
        }

        fallback = connection.copyWith(clientId: clientId);
        return fallback!;
      },
      organizationId: organizationId,
    );

    return result ?? fallback!;
  }

  Future<ConnectionEntity> updateConnection({
    required String id,
    required ConnectionEntity connection,
  }) async {
    final organizationId = await _requireOrganizationId();

    final localFallback = connection.copyWith(id: id);
    final payload = connection.toJson()..remove('stage');

    final result = await client.patch<ConnectionEntity>(
      '${ApiConstants.baseUrl}/api/v1/connections/$id',
      payload,
      (json) {
        final data = json['data'];

        if (data is Map && data.isNotEmpty) {
          return ConnectionEntity.fromJson(Map<String, dynamic>.from(data));
        }

        if (data is List && data.isNotEmpty) {
          return ConnectionEntity.fromJson(
            Map<String, dynamic>.from(data.first as Map),
          );
        }

        return localFallback;
      },
      organizationId: organizationId,
    );

    return result ?? localFallback;
  }

  Future<ConnectionEntity> updateConnectionStage({
    required String id,
    required String stage,
    required ConnectionEntity current,
  }) async {
    final organizationId = await _requireOrganizationId();

    final localFallback = current.copyWith(id: id, stage: stage);

    final result = await client.patch<ConnectionEntity>(
      '${ApiConstants.baseUrl}/api/v1/connections/$id/stage',
      {'stage': stage},
      (json) {
        final data = json['data'];

        if (data is Map && data.isNotEmpty) {
          return ConnectionEntity.fromJson(Map<String, dynamic>.from(data));
        }

        return localFallback;
      },
      organizationId: organizationId,
    );

    return result ?? localFallback;
  }

  Future<void> deleteConnection(String id) async {
    final organizationId = await _requireOrganizationId();

    await client.delete(
      '${ApiConstants.baseUrl}/api/v1/connections/$id',
      organizationId: organizationId,
    );
  }
}
