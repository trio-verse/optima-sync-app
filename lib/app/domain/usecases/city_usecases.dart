import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/city/city_repo.dart';

class CityUsecases {
  final CityRepository repo;

  CityUsecases({required this.repo});

  Future<List<CityEntity>> getCities() {
    return repo.getCities();
  }

  Future<CityEntity> createCity({required String name, required String color}) {
    return repo.createCity(name: name, color: color);
  }
}
