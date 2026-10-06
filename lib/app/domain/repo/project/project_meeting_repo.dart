import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/project_meeting_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class ProjectMeetingRepository {
  Future<Either<WhateverFailure, List<ProjectMeetingEntity>>> getMeetings(
    String projectId,
  );
}
