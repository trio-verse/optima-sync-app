import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/city/city_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class CityUsecases {
  final CityRepository repo;

  CityUsecases({required this.repo});

  Future<Either<WhateverFailure, List<CityEntity>>> getCities() {
    return repo.getCities();
  }

  Future<Either<WhateverFailure, CityEntity>> createCity({
    required String name,
    required String color,
  }) {
    return repo.createCity(name: name, color: color);
  }

  Future<Either<WhateverFailure, CityEntity>> updateCity({
    required String id,
    required String name,
    required String color,
  }) {
    return repo.updateCity(id: id, name: name, color: color);
  }

  Future<Either<WhateverFailure, void>> deleteCity(String id) {
    return repo.deleteCity(id);
  }
}
