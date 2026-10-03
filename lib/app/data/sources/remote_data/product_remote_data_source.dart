import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/product_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class _ProductPage {
  final List<ProductEntity> products;
  final int currentPage;
  final int lastPage;

  const _ProductPage({
    required this.products,
    required this.currentPage,
    required this.lastPage,
  });
}

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
    final allProducts = <ProductEntity>[];
    var page = 1;
    var lastPage = 1;

    do {
      final uri = Uri.parse(
        "${ApiConstants.baseUrl}/api/v1/products",
      ).replace(queryParameters: {"per_page": "100", "page": page.toString()});

      final result = await client.get<_ProductPage>(uri.toString(), (json) {
        final data = json["data"];
        final list = data is List ? data : (data == null ? [] : [data]);
        final products = list
            .whereType<Map>()
            .map((e) => ProductEntity.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        final meta = json["meta"] is Map
            ? Map<String, dynamic>.from(json["meta"] as Map)
            : json;
        final currentPage =
            int.tryParse('${meta["current_page"] ?? page}') ?? page;
        final parsedLastPage =
            int.tryParse('${meta["last_page"] ?? currentPage}') ?? currentPage;

        return _ProductPage(
          products: products,
          currentPage: currentPage,
          lastPage: parsedLastPage,
        );
      }, organizationId: organizationId);

      if (result == null) break;

      allProducts.addAll(result.products);
      lastPage = result.lastPage;
      page = result.currentPage + 1;
    } while (page <= lastPage && page <= 100);

    return allProducts;
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
