import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/project_feature_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class ProjectFeatureRepository {
  Future<Either<WhateverFailure, List<ProjectFeatureEntity>>> getFeatures(
    String projectId,
  );

  Future<Either<WhateverFailure, ProjectFeatureEntity>> updateFeatureStatus({
    required String projectId,
    required String featureId,
    required String status,
    required ProjectFeatureEntity current,
  });
}
