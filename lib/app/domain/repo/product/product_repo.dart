import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/product_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class ProductRepository {
  Future<Either<WhateverFailure, List<ProductEntity>>> getProducts();

  Future<Either<WhateverFailure, ProductEntity>> createProduct({
    required String name,
    required double price,
    required String description,
  });

  Future<Either<WhateverFailure, ProductEntity>> updateProduct({
    required String id,
    required String name,
    required double price,
    required String description,
  });

  Future<Either<WhateverFailure, void>> deleteProduct(String id);
}
