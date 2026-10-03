import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/project_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/project_details_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_feature_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_meeting_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/project/project_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  Future<Either<WhateverFailure, T>> _guard<T>(Future<T> request) async {
    try {
      return Right(await request);
    } catch (_) {
      return Left(WhateverFailure.serverError());
    }
  }

  @override
  Future<Either<WhateverFailure, ProjectListResult>> getProjects(
    ProjectFilter filter,
  ) => _guard(remoteDataSource.getProjects(filter));

  @override
  Future<Either<WhateverFailure, List<ProjectClientOption>>> getClients() =>
      _guard(remoteDataSource.getClients());

  @override
  Future<Either<WhateverFailure, ProjectEntity>> createProject(
    ProjectInput input,
  ) => _guard(remoteDataSource.createProject(input));

  @override
  Future<Either<WhateverFailure, ProjectEntity>> updateProject(
    String projectId,
    ProjectUpdateInput input,
  ) => _guard(remoteDataSource.updateProject(projectId, input));

  @override
  Future<Either<WhateverFailure, void>> deleteProject(String projectId) =>
      _guard(remoteDataSource.deleteProject(projectId));

  @override
  Future<Either<WhateverFailure, ProjectDetailsData>> getProjectDetails(
    String projectId,
  ) => _guard(remoteDataSource.getProjectDetails(projectId));

  @override
  Future<Either<WhateverFailure, ProjectFeatureEntity>> createFeature(
    String projectId,
    ProjectFeatureInput input,
  ) => _guard(remoteDataSource.createFeature(projectId, input));

  @override
  Future<Either<WhateverFailure, ProjectFeatureEntity>> updateFeature(
    String projectId,
    String featureId,
    ProjectFeatureInput input,
  ) => _guard(remoteDataSource.updateFeature(projectId, featureId, input));

  @override
  Future<Either<WhateverFailure, void>> deleteFeature(
    String projectId,
    String featureId,
  ) => _guard(remoteDataSource.deleteFeature(projectId, featureId));

  @override
  Future<Either<WhateverFailure, ProjectCostEntity>> createCost(
    String projectId,
    ProjectCostInput input,
  ) => _guard(remoteDataSource.createCost(projectId, input));

  @override
  Future<Either<WhateverFailure, ProjectCostEntity>> updateCost(
    String projectId,
    String costId,
    ProjectCostInput input,
  ) => _guard(remoteDataSource.updateCost(projectId, costId, input));

  @override
  Future<Either<WhateverFailure, void>> deleteCost(
    String projectId,
    String costId,
  ) => _guard(remoteDataSource.deleteCost(projectId, costId));

  @override
  Future<Either<WhateverFailure, ProjectEmployeeEntity>> addProjectEmployee(
    String projectId,
    String employeeId,
    int totalPoints,
  ) => _guard(
    remoteDataSource.addProjectEmployee(projectId, employeeId, totalPoints),
  );

  @override
  Future<Either<WhateverFailure, ProjectEmployeeEntity>>
  updateProjectEmployee(
    String projectId,
    String assignmentId,
    int totalPoints,
  ) => _guard(
    remoteDataSource.updateProjectEmployee(
      projectId,
      assignmentId,
      totalPoints,
    ),
  );

  @override
  Future<Either<WhateverFailure, void>> deleteProjectEmployee(
    String projectId,
    String assignmentId,
  ) => _guard(
    remoteDataSource.deleteProjectEmployee(projectId, assignmentId),
  );

  @override
  Future<Either<WhateverFailure, ProjectMeetingEntity>> createMeeting(
    String projectId,
    ProjectMeetingInput input,
  ) => _guard(remoteDataSource.createMeeting(projectId, input));

  @override
  Future<Either<WhateverFailure, ProjectMeetingEntity>> updateMeeting(
    String projectId,
    String meetingId,
    ProjectMeetingInput input,
  ) => _guard(remoteDataSource.updateMeeting(projectId, meetingId, input));

  @override
  Future<Either<WhateverFailure, void>> deleteMeeting(
    String projectId,
    String meetingId,
  ) => _guard(remoteDataSource.deleteMeeting(projectId, meetingId));

  @override
  Future<Either<WhateverFailure, String>> previewQuotation(
    String projectId,
    String versionId,
  ) => _guard(remoteDataSource.previewQuotation(projectId, versionId));

  @override
  Future<Either<WhateverFailure, String>> generateQuotationPdf(
    String projectId,
    String versionId,
  ) => _guard(remoteDataSource.generateQuotationPdf(projectId, versionId));
}
