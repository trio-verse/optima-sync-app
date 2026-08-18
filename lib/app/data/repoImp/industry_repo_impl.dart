import 'package:optima_sync_v2/app/data/sources/remote_data/industry_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/industry/industry_repo.dart';

class IndustryRepositoryImpl implements IndustryRepository {
  final IndustryRemoteDataSource remoteDataSource;

  IndustryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<IndustryEntity>> getIndustries() {
    return remoteDataSource.getIndustries();
  }

  @override
  Future<IndustryEntity> createIndustry(String newName, String newColor) {
    return remoteDataSource.createIndustry(newName, newColor);
  }
}
