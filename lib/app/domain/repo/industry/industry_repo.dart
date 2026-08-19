import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';

abstract class IndustryRepository {
  Future<List<IndustryEntity>> getIndustries();

  Future<IndustryEntity> createIndustry(String newName, String newColor);

  Future<IndustryEntity> updateIndustry({
    required int id,
    required String name,
    required String color,
  });
}
