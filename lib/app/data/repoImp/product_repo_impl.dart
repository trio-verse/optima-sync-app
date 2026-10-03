import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/product_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/product_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/product/product_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, List<ProductEntity>>> getProducts() async {
    try {
      final res = await remoteDataSource.getProducts();
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ProductEntity>> createProduct({
    required String name,
    required double price,
    required String description,
  }) async {
    try {
      final res = await remoteDataSource.createProduct(
        name: name,
        price: price,
        description: description,
      );
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ProductEntity>> updateProduct({
    required String id,
    required String name,
    required double price,
    required String description,
  }) async {
    try {
      final res = await remoteDataSource.updateProduct(
        id: id,
        name: name,
        price: price,
        description: description,
      );
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, void>> deleteProduct(String id) async {
    try {
      final res = await remoteDataSource.deleteProduct(id);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }
}
