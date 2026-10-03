import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/project_details_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_feature_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_meeting_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/project/project_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ProjectUsecases {
  final ProjectRepository repo;
  ProjectUsecases({required this.repo});

  Future<Either<WhateverFailure, ProjectListResult>> getProjects(
    ProjectFilter filter,
  ) => repo.getProjects(filter);
  Future<Either<WhateverFailure, List<ProjectClientOption>>> getClients() =>
      repo.getClients();
  Future<Either<WhateverFailure, ProjectEntity>> createProject(
    ProjectInput input,
  ) => repo.createProject(input);
  Future<Either<WhateverFailure, ProjectEntity>> updateProject(
    String projectId,
    ProjectUpdateInput input,
  ) => repo.updateProject(projectId, input);
  Future<Either<WhateverFailure, void>> deleteProject(String projectId) =>
      repo.deleteProject(projectId);
  Future<Either<WhateverFailure, ProjectDetailsData>> getProjectDetails(
    String projectId,
  ) => repo.getProjectDetails(projectId);
  Future<Either<WhateverFailure, ProjectFeatureEntity>> createFeature(
    String projectId,
    ProjectFeatureInput input,
  ) => repo.createFeature(projectId, input);
  Future<Either<WhateverFailure, ProjectFeatureEntity>> updateFeature(
    String projectId,
    String featureId,
    ProjectFeatureInput input,
  ) => repo.updateFeature(projectId, featureId, input);
  Future<Either<WhateverFailure, void>> deleteFeature(
    String projectId,
    String featureId,
  ) => repo.deleteFeature(projectId, featureId);
  Future<Either<WhateverFailure, ProjectCostEntity>> createCost(
    String projectId,
    ProjectCostInput input,
  ) => repo.createCost(projectId, input);
  Future<Either<WhateverFailure, ProjectCostEntity>> updateCost(
    String projectId,
    String costId,
    ProjectCostInput input,
  ) => repo.updateCost(projectId, costId, input);
  Future<Either<WhateverFailure, void>> deleteCost(
    String projectId,
    String costId,
  ) => repo.deleteCost(projectId, costId);
  Future<Either<WhateverFailure, ProjectEmployeeEntity>> addProjectEmployee(
    String projectId,
    String employeeId,
    int totalPoints,
  ) => repo.addProjectEmployee(projectId, employeeId, totalPoints);
  Future<Either<WhateverFailure, ProjectEmployeeEntity>>
  updateProjectEmployee(
    String projectId,
    String assignmentId,
    int totalPoints,
  ) => repo.updateProjectEmployee(projectId, assignmentId, totalPoints);
  Future<Either<WhateverFailure, void>> deleteProjectEmployee(
    String projectId,
    String assignmentId,
  ) => repo.deleteProjectEmployee(projectId, assignmentId);
  Future<Either<WhateverFailure, ProjectMeetingEntity>> createMeeting(
    String projectId,
    ProjectMeetingInput input,
  ) => repo.createMeeting(projectId, input);
  Future<Either<WhateverFailure, ProjectMeetingEntity>> updateMeeting(
    String projectId,
    String meetingId,
    ProjectMeetingInput input,
  ) => repo.updateMeeting(projectId, meetingId, input);
  Future<Either<WhateverFailure, void>> deleteMeeting(
    String projectId,
    String meetingId,
  ) => repo.deleteMeeting(projectId, meetingId);
  Future<Either<WhateverFailure, String>> previewQuotation(
    String projectId,
    String versionId,
  ) => repo.previewQuotation(projectId, versionId);
  Future<Either<WhateverFailure, String>> generateQuotationPdf(
    String projectId,
    String versionId,
  ) => repo.generateQuotationPdf(projectId, versionId);
}
