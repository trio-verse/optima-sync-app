import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/city_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/city/city_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class CityRepositoryImpl implements CityRepository {
  final CityRemoteDataSource remoteDataSource;

  CityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, List<CityEntity>>> getCities() async {
    try {
      final result = await remoteDataSource.getCities();
      return Right(result);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, CityEntity>> createCity({
    required String name,
    required String color,
  }) async {
    try {
      final result = await remoteDataSource.createCity(
        name: name,
        color: color,
      );
      return Right(result);
    } catch (e) {
      return left(WhateverFailure.database());
    }
  }

  @override
  Future<Either<WhateverFailure, CityEntity>> updateCity({
    required String id,
    required String name,
    required String color,
  }) async {
    try {
      final result = await remoteDataSource.updateCity(
        id: id,
        name: name,
        color: color,
      );
      return right(result);
    } catch (e) {
      return left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, void>> deleteCity(String id) async {
    try {
      final result = await remoteDataSource.deleteCity(id);
      return right(result);
    } catch (e) {
      return left(WhateverFailure.whatoffline());
    }
  }
}
