import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/project_meeting_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/project/project_meeting_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ProjectMeetingUsecases {
  final ProjectMeetingRepository repo;

  ProjectMeetingUsecases({required this.repo});

  Future<Either<WhateverFailure, List<ProjectMeetingEntity>>> getMeetings(
    String projectId,
  ) {
    return repo.getMeetings(projectId);
  }
}
