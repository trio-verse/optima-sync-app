import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/industry/industry_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class IndustryUsecases {
  final IndustryRepository repo;

  IndustryUsecases({required this.repo});

  Future<Either<WhateverFailure, List<IndustryEntity>>> getIndustries() {
    return repo.getIndustries();
  }

  Future<Either<WhateverFailure, IndustryEntity>> createIndustry(
    String newName,
    String newColor,
  ) {
    return repo.createIndustry(newName, newColor);
  }

  Future<Either<WhateverFailure, IndustryEntity>> updateIndustry({
    required int id,
    required String name,
    required String color,
  }) {
    return repo.updateIndustry(id: id, name: name, color: color);
  }

  Future<Either<WhateverFailure, void>> deleteIndustry({required int id}) {
    return repo.deleteIndustry(id: id);
  }
}
