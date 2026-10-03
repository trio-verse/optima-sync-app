import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/project_details_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_feature_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_meeting_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class ProjectRepository {
  Future<Either<WhateverFailure, ProjectListResult>> getProjects(
    ProjectFilter filter,
  );
  Future<Either<WhateverFailure, List<ProjectClientOption>>> getClients();
  Future<Either<WhateverFailure, ProjectEntity>> createProject(
    ProjectInput input,
  );
  Future<Either<WhateverFailure, ProjectEntity>> updateProject(
    String projectId,
    ProjectUpdateInput input,
  );
  Future<Either<WhateverFailure, void>> deleteProject(String projectId);
  Future<Either<WhateverFailure, ProjectDetailsData>> getProjectDetails(
    String projectId,
  );
  Future<Either<WhateverFailure, ProjectFeatureEntity>> createFeature(
    String projectId,
    ProjectFeatureInput input,
  );
  Future<Either<WhateverFailure, ProjectFeatureEntity>> updateFeature(
    String projectId,
    String featureId,
    ProjectFeatureInput input,
  );
  Future<Either<WhateverFailure, void>> deleteFeature(
    String projectId,
    String featureId,
  );
  Future<Either<WhateverFailure, ProjectCostEntity>> createCost(
    String projectId,
    ProjectCostInput input,
  );
  Future<Either<WhateverFailure, ProjectCostEntity>> updateCost(
    String projectId,
    String costId,
    ProjectCostInput input,
  );
  Future<Either<WhateverFailure, void>> deleteCost(
    String projectId,
    String costId,
  );
  Future<Either<WhateverFailure, ProjectEmployeeEntity>> addProjectEmployee(
    String projectId,
    String employeeId,
    int totalPoints,
  );
  Future<Either<WhateverFailure, ProjectEmployeeEntity>>
  updateProjectEmployee(
    String projectId,
    String assignmentId,
    int totalPoints,
  );
  Future<Either<WhateverFailure, void>> deleteProjectEmployee(
    String projectId,
    String assignmentId,
  );
  Future<Either<WhateverFailure, ProjectMeetingEntity>> createMeeting(
    String projectId,
    ProjectMeetingInput input,
  );
  Future<Either<WhateverFailure, ProjectMeetingEntity>> updateMeeting(
    String projectId,
    String meetingId,
    ProjectMeetingInput input,
  );
  Future<Either<WhateverFailure, void>> deleteMeeting(
    String projectId,
    String meetingId,
  );
  Future<Either<WhateverFailure, String>> previewQuotation(
    String projectId,
    String versionId,
  );
  Future<Either<WhateverFailure, String>> generateQuotationPdf(
    String projectId,
    String versionId,
  );
}
