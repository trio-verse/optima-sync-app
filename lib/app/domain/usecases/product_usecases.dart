import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/product_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/product/product_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ProductUsecases {
  final ProductRepository repo;

  ProductUsecases({required this.repo});

  Future<Either<WhateverFailure, List<ProductEntity>>> getProducts() {
    return repo.getProducts();
  }

  Future<Either<WhateverFailure, ProductEntity>> createProduct({
    required String name,
    required double price,
    required String description,
  }) {
    return repo.createProduct(name: name, price: price, description: description);
  }

  Future<Either<WhateverFailure, ProductEntity>> updateProduct({
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

  Future<Either<WhateverFailure, void>> deleteProduct(String id) {
    return repo.deleteProduct(id);
  }
}
