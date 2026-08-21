import 'package:optima_sync_v2/app/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();

  Future<ProductEntity> createProduct({
    required String name,
    required double price,
    required String description,
  });

  Future<ProductEntity> updateProduct({
    required String id,
    required String name,
    required double price,
    required String description,
  });

  Future<void> deleteProduct(String id);
}
