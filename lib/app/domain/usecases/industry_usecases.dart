import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/industry/industry_repo.dart';

class IndustryUsecases {
  final IndustryRepository repo;

  IndustryUsecases({required this.repo});

  Future<List<IndustryEntity>> getIndustries() {
    return repo.getIndustries();
  }

  Future<IndustryEntity> createIndustry(String newName, String newColor) {
    return repo.createIndustry(newName, newColor);
  }

  Future<IndustryEntity> updateIndustry({
    required int id,
    required String name,
    required String color,
  }) {
    return repo.updateIndustry(id: id, name: name, color: color);
  }

  Future<void> deleteIndustry({required int id}) {
    return repo.deleteIndustry(id: id);
  }
}
