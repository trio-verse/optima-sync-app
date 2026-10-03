import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class IndustryRepository {
  Future<Either<WhateverFailure, List<IndustryEntity>>> getIndustries();

  Future<Either<WhateverFailure, IndustryEntity>> createIndustry(
    String newName,
    String newColor,
  );

  Future<Either<WhateverFailure, IndustryEntity>> updateIndustry({
    required int id,
    required String name,
    required String color,
  });
  Future<Either<WhateverFailure, void>> deleteIndustry({required int id});
}
