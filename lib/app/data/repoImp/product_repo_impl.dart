import 'package:optima_sync_v2/app/data/sources/remote_data/product_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/product_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/product/product_repo.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductEntity>> getProducts() {
    return remoteDataSource.getProducts();
  }

  @override
  Future<ProductEntity> createProduct({
    required String name,
    required double price,
    required String description,
  }) {
    return remoteDataSource.createProduct(
      name: name,
      price: price,
      description: description,
    );
  }

  @override
  Future<ProductEntity> updateProduct({
    required String id,
    required String name,
    required double price,
    required String description,
  }) {
    return remoteDataSource.updateProduct(
      id: id,
      name: name,
      price: price,
      description: description,
    );
  }

  @override
  Future<void> deleteProduct(String id) {
    return remoteDataSource.deleteProduct(id);
  }
}
