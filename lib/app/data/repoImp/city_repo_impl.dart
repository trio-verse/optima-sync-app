import 'package:optima_sync_v2/app/data/sources/remote_data/city_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/city/city_repo.dart';

class CityRepositoryImpl implements CityRepository {
  final CityRemoteDataSource remoteDataSource;

  CityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CityEntity>> getCities() {
    return remoteDataSource.getCities();
  }

  @override
  Future<CityEntity> createCity({required String name, required String color}) {
    return remoteDataSource.createCity(name: name, color: color);
  }

  @override
  Future<CityEntity> updateCity({
    required String id,
    required String name,
    required String color,
  }) {
    return remoteDataSource.updateCity(id: id, name: name, color: color);
  }

  @override
  Future<void> deleteCity(String id) {
    return remoteDataSource.deleteCity(id);
  }
}
