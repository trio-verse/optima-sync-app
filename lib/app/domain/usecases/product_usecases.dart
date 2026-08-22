import 'package:optima_sync_v2/app/domain/entities/product_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/product/product_repo.dart';

class ProductUsecases {
  final ProductRepository repo;

  ProductUsecases({required this.repo});

  Future<List<ProductEntity>> getProducts() {
    return repo.getProducts();
  }

  Future<ProductEntity> createProduct({
    required String name,
    required double price,
    required String description,
  }) {
    return repo.createProduct(name: name, price: price, description: description);
  }

  Future<ProductEntity> updateProduct({
    required String id,
    required String name,
    required double price,
    required String description,
  }) {
    return repo.updateProduct(
      id: id,
      name: name,
      price: price,
      description: description,
    );
  }

  Future<void> deleteProduct(String id) {
    return repo.deleteProduct(id);
  }
}
