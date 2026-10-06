import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/employee_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class EmployeeRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  EmployeeRemoteDataSource({
    required this.client,
    required this.orgLocalDataSource,
  });

  Future<String> _organizationId() async {
    final id = await orgLocalDataSource.getSelectedOrganization();
    if (id == null || id.isEmpty) {
      throw Exception('No selected organization found');
    }
    return id;
  }

  EmployeeEntity _parseOne(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map) {
      return EmployeeEntity.fromJson(Map<String, dynamic>.from(data));
    }
    return EmployeeEntity.fromJson(json);
  }

  Future<List<EmployeeEntity>> getEmployees() async {
    final organizationId = await _organizationId();
    final result = await client.get<List<EmployeeEntity>>(
      '${ApiConstants.baseUrl}/api/v1/hr/employees',
      (json) {
        final raw = json['data'];
        final list = raw is List
            ? raw
            : raw is Map && raw['data'] is List
            ? raw['data'] as List
            : const [];
        return list
            .whereType<Map>()
            .map(
              (item) => EmployeeEntity.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      },
      organizationId: organizationId,
    );
    return result ?? [];
  }

  Future<EmployeeEntity> createEmployee(EmployeeInput input) async {
    final organizationId = await _organizationId();
    final result = await client.post<EmployeeEntity>(
      '${ApiConstants.baseUrl}/api/v1/hr/employees',
      input.toJson(),
      _parseOne,
      organizationId: organizationId,
      acceptedStatusCodes: const [200, 201],
    );
    return result!;
  }

  Future<EmployeeEntity> updateEmployee(
    String employeeId,
    EmployeeInput input,
  ) async {
    final organizationId = await _organizationId();
    final result = await client.patch<EmployeeEntity>(
      '${ApiConstants.baseUrl}/api/v1/hr/employees/$employeeId',
      input.toJson(),
      _parseOne,
      organizationId: organizationId,
    );
    return result!;
  }

  Future<void> deleteEmployee(String employeeId) async {
    final organizationId = await _organizationId();
    await client.delete(
      '${ApiConstants.baseUrl}/api/v1/hr/employees/$employeeId',
      organizationId: organizationId,
    );
  }
}
