import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/project_feature_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/project_feature_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/project/project_feature_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ProjectFeatureRepositoryImpl implements ProjectFeatureRepository {
  final ProjectFeatureRemoteDataSource remoteDataSource;

  ProjectFeatureRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, List<ProjectFeatureEntity>>> getFeatures(
    String projectId,
  ) async {
    try {
      final res = await remoteDataSource.getFeatures(projectId);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ProjectFeatureEntity>> updateFeatureStatus({
    required String projectId,
    required String featureId,
    required String status,
    required ProjectFeatureEntity current,
  }) async {
    try {
      final res = await remoteDataSource.updateFeatureStatus(
        projectId: projectId,
        featureId: featureId,
        status: status,
        current: current,
      );
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }
}
