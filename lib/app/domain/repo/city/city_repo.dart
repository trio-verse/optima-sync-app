import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class CityRepository {
  Future<Either<WhateverFailure, List<CityEntity>>> getCities();

  Future<Either<WhateverFailure, CityEntity>> createCity({
    required String name,
    required String color,
  });

  Future<Either<WhateverFailure, CityEntity>> updateCity({
    required String id,
    required String name,
    required String color,
  });
  Future<Either<WhateverFailure, void>> deleteCity(String id);
}
