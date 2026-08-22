import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/product_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class ProductRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  ProductRemoteDataSource({
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

  Future<List<ProductEntity>> getProducts() async {
    final organizationId = await _requireOrganizationId();

    final result = await client.get<List<ProductEntity>>(
      "${ApiConstants.baseUrl}/api/v1/products",
      (json) {
        return (json["data"] as List)
            .map((e) => ProductEntity.fromJson(e))
            .toList();
      },
      organizationId: organizationId,
    );

    return result!;
  }

  Future<ProductEntity> createProduct({
    required String name,
    required double price,
    required String description,
  }) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.post<ProductEntity>(
      "${ApiConstants.baseUrl}/api/v1/products",
      {"name": name, "price": price, "description": description},
      (json) {
        return ProductEntity.fromJson(json["data"]);
      },
      organizationId: organizationId,
    );

    return result!;
  }

  Future<ProductEntity> updateProduct({
    required String id,
    required String name,
    required double price,
    required String description,
  }) async {
    final organizationId = await _requireOrganizationId();

    final result = await client.patch<ProductEntity>(
      "${ApiConstants.baseUrl}/api/v1/products/$id",
      {"name": name, "price": price, "description": description},
      (json) => ProductEntity.fromJson(json["data"]),
      organizationId: organizationId,
    );

    return result!;
  }

  Future<void> deleteProduct(String id) async {
    final organizationId = await _requireOrganizationId();

    await client.delete(
      "${ApiConstants.baseUrl}/api/v1/products/$id",
      organizationId: organizationId,
    );
  }
}
