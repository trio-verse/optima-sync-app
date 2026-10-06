import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/project_feature_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/project/project_feature_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ProjectFeatureUsecases {
  final ProjectFeatureRepository repo;

  ProjectFeatureUsecases({required this.repo});

  Future<Either<WhateverFailure, List<ProjectFeatureEntity>>> getFeatures(
    String projectId,
  ) {
    return repo.getFeatures(projectId);
  }

  Future<Either<WhateverFailure, ProjectFeatureEntity>> updateFeatureStatus({
    required String projectId,
    required String featureId,
    required String status,
    required ProjectFeatureEntity current,
  }) {
    return repo.updateFeatureStatus(
      projectId: projectId,
      featureId: featureId,
      status: status,
      current: current,
    );
  }
}
