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
        final data = json["data"];
        final list = data is List ? data : [data];

        return list
            .map((e) => ProductEntity.fromJson(Map<String, dynamic>.from(e)))
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

    ProductEntity? fallback;

    final result = await client.post<ProductEntity>(
      "${ApiConstants.baseUrl}/api/v1/products",
      {"name": name, "price": price, "description": description},
      (json) {
        final data = json["data"];

        if (data is Map && data.isNotEmpty) {
          return ProductEntity.fromJson(Map<String, dynamic>.from(data));
        }

        if (data is List && data.isNotEmpty) {
          return ProductEntity.fromJson(
            Map<String, dynamic>.from(data.first as Map),
          );
        }

        // The server confirmed creation (status 201) but didn't return
        // the created object (e.g. an empty "data" list). We don't have
        // a server-issued id in that case, so the caller should reload
        // the list to pick up the new product and its id.
        fallback = ProductEntity(
          name: name,
          price: price,
          description: description,
        );

        return fallback!;
      },
      organizationId: organizationId,
    );

    return result ?? fallback!;
  }

  Future<ProductEntity> updateProduct({
    required String id,
    required String name,
    required double price,
    required String description,
  }) async {
    final organizationId = await _requireOrganizationId();

    // We already know what the product should look like after a
    // successful update (we're the ones sending these values). The
    // server confirms success with a 200, but its response body doesn't
    // reliably contain the updated object (sometimes it's an empty
    // list). So we use the server's copy when available, and fall back
    // to our own local copy instead of treating "no data" as failure.
    final localFallback = ProductEntity(
      id: id,
      name: name,
      price: price,
      description: description,
    );

    final result = await client.patch<ProductEntity>(
      "${ApiConstants.baseUrl}/api/v1/products/$id",
      {"name": name, "price": price, "description": description},
      (json) {
        final data = json["data"];

        if (data is Map && data.isNotEmpty) {
          return ProductEntity.fromJson(Map<String, dynamic>.from(data));
        }

        if (data is List && data.isNotEmpty) {
          return ProductEntity.fromJson(
            Map<String, dynamic>.from(data.first as Map),
          );
        }

        return localFallback;
      },
      organizationId: organizationId,
    );

    return result ?? localFallback;
  }

  Future<void> deleteProduct(String id) async {
    final organizationId = await _requireOrganizationId();

    await client.delete(
      "${ApiConstants.baseUrl}/api/v1/products/$id",
      organizationId: organizationId,
    );
  }
}
