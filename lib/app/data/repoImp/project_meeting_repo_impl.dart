import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/project_meeting_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/project_meeting_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/project/project_meeting_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ProjectMeetingRepositoryImpl implements ProjectMeetingRepository {
  final ProjectMeetingRemoteDataSource remoteDataSource;

  ProjectMeetingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, List<ProjectMeetingEntity>>> getMeetings(
    String projectId,
  ) async {
    try {
      final res = await remoteDataSource.getMeetings(projectId);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }
}
