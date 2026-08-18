import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';

abstract class CityRepository {
  Future<List<CityEntity>> getCities();

  Future<CityEntity> createCity({required String name, required String color});
}
