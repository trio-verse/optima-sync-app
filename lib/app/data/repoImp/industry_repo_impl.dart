import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/industry_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/industry/industry_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class IndustryRepositoryImpl implements IndustryRepository {
  final IndustryRemoteDataSource remoteDataSource;

  IndustryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, List<IndustryEntity>>> getIndustries() async {
    try {
      final res = await remoteDataSource.getIndustries();
      return Right(res);
    } catch (e) {
      return Left(.serverError());
    }
  }

  @override
  Future<Either<WhateverFailure, IndustryEntity>> createIndustry(
    String newName,
    String newColor,
  ) async {
    try {
      final res = await remoteDataSource.createIndustry(newName, newColor);
      return Right(res);
    } catch (e) {
      return Left(.serverError());
    }
  }

  @override
  Future<Either<WhateverFailure, IndustryEntity>> updateIndustry({
    required int id,
    required String name,
    required String color,
  }) async {
    try {
      final res = await remoteDataSource.updateIndustry(
        id.toString(),
        name,
        color,
      );
      return Right(res);
    } catch (e) {
      return Left(.serverError());
    }
  }

  @override
  Future<Either<WhateverFailure, void>> deleteIndustry({
    required int id,
  }) async {
    try {
      final res = await remoteDataSource.deleteIndustry(id: id);
      return Right(res);
    } catch (e) {
      return Left(.serverError());
    }
  }
}
